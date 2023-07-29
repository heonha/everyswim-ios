//
//  HealthKitManager.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import HealthKit
import SwiftUI
import CoreLocation

class HealthKitManager {
    
    typealias HKStatCollectionQuery = HKStatisticsCollectionQuery
    typealias HKStatCollection = HKStatisticsCollection
    typealias HKDataTypeId = HKQuantityTypeIdentifier
    
    private let healthStore: HKHealthStore?
    private var query: HKStatCollectionQuery?
    var isAuth = false
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            print("INIT: HealthKitManager")
            healthStore = HKHealthStore()
        } else {
            healthStore = nil
        }
    }
    
    deinit {
        print("DEUBG DEINIT: HealthKitManager")
    }
    
}

extension HealthKitManager {
    
    // TODO: Workout Event 핸들링
    // - 연속 발생한 Lap들을 묶는다.
    // - Lap이 연속 발생한 시간을 누적한다.
    // - Lap이 연속 발생한 개수에 따라 수영장 길이를 곱해준다. `(연속 Lap 수 x 수영장 길이)`
    // - Segment가 발생하면 랩 수를 1올리고 새로운 배열을 만든다.
    // - Segment가 시간은 Swim Time이다.
    // - Segment와 그 다음 Lap사이의 시간은 RestTime이다.
    
    func mergeLaps(data: [HKWorkoutEvent]?) -> [Lap] {
        guard let data = data else { return [] }
        
        var laps: [Lap] = []
        var lapCount: Int = 0
        
        for datum in data {
            if datum.type == .lap {
                lapCount += 1
                
                if let styleNo = datum.metadata?["HKSwimmingStrokeStyle"] as? Int {
                    let style = StrokeStyle(rawValue: styleNo)
                    let newLap = Lap(index: 0, dateInterval: datum.dateInterval, style: style)
                    laps.append(newLap)
                } else {
                    let newLap = Lap(index: 0, dateInterval: datum.dateInterval, style: nil)
                    laps.append(newLap)
                }
            } else {
                continue
            }
        }
        
        return laps
        
    }
    
    
}


// MARK: - Swimming Data
extension HealthKitManager {
    
    func loadSwimmingDataCollection() async -> [SwimMainData] {
        
        let result = await self.requestAuthorization()
        if result == false { return [] }
        
        let records = await readSwimmingWorkoutData()
        var swimmingData: [SwimMainData] = []

        guard let workouts = records else { return [] }

        for workout in workouts {
            // 운동 한 기간 (운동 지속시간)
            let id = workout.uuid
            let duration = workout.duration
            let startDate = workout.startDate
            let endDate = workout.endDate
            // let workoutEvent = getWorkoutEvents(workout)
            let laps = mergeLaps(data: workout.workoutEvents)
            // 거리
            if #available(iOS 16.0, *) {
                let allStat = allStatDataHandler(workout)
                let detail = SwimStatisticsData(distance: allStat.distance,
                                                stroke: allStat.stroke,
                                                activeKcal: allStat.activeKcal,
                                                restKcal: allStat.restKcal)
                let data = SwimMainData(id: id,
                                        duration: duration,
                                        startDate: startDate,
                                        endDate: endDate,
                                        detail: detail,
                                        laps: laps)
                swimmingData.append(data)
                
            } else {
                let data = SwimMainData(id: id,
                                        duration: duration,
                                        startDate: startDate,
                                        endDate: endDate,
                                        detail: nil,
                                        laps: laps
                )
                swimmingData.append(data)
            }
        }
        return swimmingData
    }
    
    private func allStatDataHandlerForiOS15(_ record: HKWorkout) -> SwimStatisticsData {
                
        let distance = 0.0
        let stroke =  0.0
        let activeKcal =  0.0
        let restKcal =  0.0
        
        return SwimStatisticsData(distance: distance, stroke: stroke, activeKcal: activeKcal, restKcal: restKcal)
    }
    
    @available (iOS 16.0, *)
    private func allStatDataHandler(_ record: HKWorkout) -> SwimStatisticsData {
        
            let allStat = record.allStatistics
            print("Key Allstat \(allStat)")
        print("Key Allstat \(allStat)")

            let distance = allStat[.init(.distanceSwimming)]?.sumQuantity()?.doubleValue(for: .meter())
            let stroke = allStat[.init(.swimmingStrokeCount)]?.sumQuantity()?.doubleValue(for: .count())
            let activeKcal = allStat[.init(.activeEnergyBurned)]?.sumQuantity()?.doubleValue(for: .kilocalorie())
            let restKcal = allStat[.init(.basalEnergyBurned)]?.sumQuantity()?.doubleValue(for: .kilocalorie())
        
        
        return SwimStatisticsData(distance: distance, stroke: stroke, activeKcal: activeKcal, restKcal: restKcal)
    }
    
    private func getWorkoutEvents(_ record: HKWorkout) -> [SwimLapEvent] {
        guard let rawEvent = record.workoutEvents else { return [] }
        
        let eventCount = rawEvent.count
        print("총이벤트갯수: \(eventCount)")
        var index = 0
        print("index,이벤트타입,일시,시작시간,종료시간,지속시간,")
        let events = rawEvent.map { event in
            let eventType = event.type
            let date = event.dateInterval
            let durationTime = (event.dateInterval.end.timeIntervalSince1970 - event.dateInterval.start.timeIntervalSince1970)
            
            print("\(index),\(eventType.rawValue),\(date),\(date.start),\(date.end),\(durationTime.formattedString()),\(event.metadata?["HKSwimmingStrokeStyle"] ?? "-")")
            
//            print("\(index)------------------------------")
//            print("이벤트타입: \(eventType.rawValue)")
//            print("일시: \(date)")
//            print("시간: \(start) ~ \(end)")
//            print("지속시간 \(durationTime.formattedString())")
//            print("메타데이터: \(event.metadata ?? [:])")
            index += 1
            
            return SwimLapEvent(type: eventType, date: date, duration: durationTime, metadata: event.metadata ?? [:])
        }
        
        return events
    }
    
}

// MARK: - 일반 건강 데이터 가져오기
extension HealthKitManager {
    
    
    func getHealthData(dataType: HKQueryDataType, queryRange: HKDateType, completion: @escaping (HKStatCollection?) -> Void) {
        calculateHealthData(dataType: dataType, queryRange: queryRange, completion: completion)
    }
    
    private func calculateHealthData(dataType: HKQueryDataType,
                                     queryRange: HKDateType,
                                     completion: @escaping (HKStatCollection?) -> Void) {
        print("데이터 계산 시작")
        guard let healthDataType = dataType.dataType() else { completion(nil); return }
        
        let startDate = Calendar.current.date(byAdding: .day, value: queryRange.value(), to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        // 쿼리 수행
        print("데이터 쿼리 만들기 시작")
        query = HKStatCollectionQuery(quantityType: healthDataType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum,
                                      anchorDate: anchorDate,
                                      intervalComponents: daily)
        
        guard let query = query else { completion(nil); return }
        
        query.initialResultsHandler = { _, staticsCollection, _ in
            completion(staticsCollection)
        }
        
        healthStore?.execute(query)
    }
    
}

// MARK: - 수영 운동기록 가져오기
extension HealthKitManager {
        
    func readSwimmingWorkoutData() async -> [HKWorkout]? {

        let swimming = HKQuery.predicateForWorkouts(with: .swimming)
        
        let sortDescriptors: [NSSortDescriptor]? = [.init(keyPath: \HKSample.startDate, ascending: false)]
        
        let samples = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            
            let query = HKSampleQuery(sampleType: .workoutType(),
                                      predicate: swimming,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: sortDescriptors) { _, samples, error in
                if let error = error {
                    print("Swimming 가져오기 Error: \(error.localizedDescription).")
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples else { print("수영 데이터 샘플값이 nil입니다."); return }
                
                continuation.resume(returning: samples)
            }

            healthStore?.execute(query)
        }
        
        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }
        
        return workouts
    }
    
    func readWorkoutActivity() async -> [HKWorkout]? {
        
        print("Swimming Data가져오기 준비")
        // predicate
        let swimming = HKQuery.predicateForWorkouts(with: .swimming)
        
        // sortDescriptors
        let sortDescriptors: [NSSortDescriptor]? = [.init(keyPath: \HKSample.startDate, ascending: false)]
        
        print("Swimming 가져오기 준비 완료")
        let samples = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            print("Swimming 가져오기를 시작합니다.")
            
            let query = HKSampleQuery(sampleType: .workoutType(),
                                      predicate: swimming,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: sortDescriptors) { _, samples, error in
                
                if let error = error {
                    print("Swimming 가져오기 Error: \(error.localizedDescription).")
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples else { print("수영 데이터 샘플값이 nil입니다."); return }
                
                continuation.resume(returning: samples)
            }
            
            print("Swimming 가져오기: 쿼리를 시작합니다. \(query)")
            healthStore?.execute(query)
        }
        
        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }
        
        return workouts
    }
    
    func getWorkoutRoute(workout: HKWorkout) async -> [HKWorkoutRoute]? {
        let byWorkout = HKQuery.predicateForObjects(from: workout)

        let samples = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore?.execute(HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: byWorkout, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { (query, samples, deletedObjects, anchor, error) in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    return
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkoutRoute] else {
            return nil
        }

        return workouts
    }
    
    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        let locations = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var allLocations: [CLLocation] = []
            
            // Create the route query.
            let query = HKWorkoutRouteQuery(route: givenRoute) { _, currentLocations, success, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let currentLocations = currentLocations else {
                    print("DEBUG: 위치값이 nil입니다.")
                    return
                }
                
                allLocations.append(contentsOf: currentLocations)
                
                if success {
                    continuation.resume(returning: allLocations)
                }
            }
            healthStore?.execute(query)
        }
        
        if let locations = locations {
            return locations
        } else {
            print("DEBUG: 수영 한 곳의 위치를 확인할 수 없음")
            return []
        }
    }
    
}

// MARK: - 권한 관련
extension HealthKitManager {

    func checkAuthorizationStatus() -> HKAuthorizationStatus? {
        return healthStore?.authorizationStatus(for: .workoutType())
    }

    
    func requestAuthorization() async -> Bool {
        let write: Set<HKSampleType> = [.workoutType()]
        let read: Set = healthDataType()
        
        let res: ()? = try? await healthStore?.requestAuthorization(toShare: write, read: read)
        guard res != nil else {
            return false
        }
        return true
    }
    
    func checkAuthorizationStatus(_ type: HKQueryDataType?) async -> Bool {
        guard let healthDataType = type?.dataType() else {
            print("Invalid HealthKit data type.")
            return false
        }
        
        let authorizationStatus = healthStore?.authorizationStatus(for: healthDataType)
        
        switch authorizationStatus {
        case .sharingAuthorized:
            print("HealthKit authorization is currently granted.")
            return true
        case .notDetermined:
            print("HealthKit authorization is currently notDetermined.")
        case .sharingDenied:
            print("HealthKit authorization is currently sharingDenied.")
        case .none:
            print("HealthKit authorization is None.")
        case .some(let somes):
            print("HealthKit authorization is \(somes).")
        }
        
        return false
    }
    
}

// MARK: Helper
extension HealthKitManager {
    
    func excuteQuery(healthStore: HKHealthStore?, query: HKStatCollectionQuery?) {
        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }
    
    private func healthDataType() -> Set<HKObjectType> {
        let set: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKSeriesType.workoutType(),
            // 활동
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.activeEnergyBurned)!, // 활동 에너지
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.swimmingStrokeCount)!, // 스트로크
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.distanceSwimming)! // 수영 거리
        ]
        
        return set
    }
    
}
