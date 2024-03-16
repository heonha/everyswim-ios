//
//  SwimDataManager.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/29.
//

import Foundation
import HealthKit

class SwimDataManager {
    
    private var healthStore: HKHealthStore?
    
    init(store: HKHealthStore?) {
        self.healthStore = store
    }
    
}

extension SwimDataManager {
    
    /// 기기에서 수영 데이터 가져오기
    func fetchSwimDataFromDevice() async throws -> [HKWorkout]? {

        let swimming = HKQuery.predicateForWorkouts(with: .swimming)
        let sort: [NSSortDescriptor]? = [.init(keyPath: \HKSample.endDate, ascending: false)]
        
        do {
            let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
                let query = makeSwimmingDataQuery(workoutType: swimming, sort: sort, continuation: continuation)
                healthStore?.execute(query)
            }
            
            guard let workouts = samples as? [HKWorkout] else {
                throw HealthKitError.dataFetchError
            }
            
            return workouts
        } catch {
            throw error
        }
        
    }
    
    /// 수영데이터 쿼리 수행
    private func makeSwimmingDataQuery(workoutType: NSPredicate,
                                       sort sortDescriptors: [NSSortDescriptor]?,
                                       continuation: CheckedContinuation<[HKSample], Error>) -> HKSampleQuery {
        
        let query = HKSampleQuery(sampleType: .workoutType(),
                                  predicate: workoutType,
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
        
        return query
    }
    
    /// Health에서 가져온 Raw 데이터로 Swim Main Data를 생성합니다.
    func transformHKWorkoutToSwimData(_ workouts: [HKWorkout]) -> [SwimMainData] {
        var swimmingData: [SwimMainData] = []

        for workout in workouts {
            
            let id = workout.uuid
            let duration = workout.duration
            let startDate = workout.startDate
            let endDate = workout.endDate
            // let workoutEvent = getWorkoutEvents(workout)
            let laps = mergeLaps(data: workout.workoutEvents)
            print("LENGTHMETA: \(workout.metadata?["HKMetadataKeyLapLength"] ?? "nil")")
            
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
        
        swimmingData.sort { $0.startDate < $1.startDate }
        
        return swimmingData
    }
    
    @available (iOS 16.0, *)
    func allStatDataHandler(_ record: HKWorkout) -> SwimStatisticsData {
        
        let allStat = record.allStatistics
        let distance = allStat[.init(.distanceSwimming)]?.sumQuantity()?.doubleValue(for: .meter())
        let stroke = allStat[.init(.swimmingStrokeCount)]?.sumQuantity()?.doubleValue(for: .count())
        let activeKcal = allStat[.init(.activeEnergyBurned)]?.sumQuantity()?.doubleValue(for: .kilocalorie())
        let restKcal = allStat[.init(.basalEnergyBurned)]?.sumQuantity()?.doubleValue(for: .kilocalorie())
        
        return SwimStatisticsData(distance: distance, stroke: stroke, activeKcal: activeKcal, restKcal: restKcal)
    }
    
    private func allStatDataHandlerForiOS15(_ record: HKWorkout) -> SwimStatisticsData {
        
        let distance = 0.0
        let stroke =  0.0
        let activeKcal =  0.0
        let restKcal =  0.0
        
        return SwimStatisticsData(distance: distance, stroke: stroke, activeKcal: activeKcal, restKcal: restKcal)
    }
    
}

// MARK: - Swimming Event Data
// TODO: Workout Event 핸들링
// - [x] 연속 발생한 Lap들을 묶는다.
// - [ ] Lap이 연속 발생한 시간을 누적한다.
// - [ ] Lap이 연속 발생한 개수에 따라 수영장 길이를 곱해준다. `(연속 Lap 수 x 수영장 길이)`
// - [ ] Segment가 발생하면 랩 수를 1올리고 새로운 배열을 만든다.
// - [ ] Segment가 시간은 Swim Time이다.
// - [ ] Segment와 그 다음 Lap사이의 시간은 RestTime이다.
extension SwimDataManager {
    
    func getWorkoutEvents(_ record: HKWorkout) -> [SwimLapEvent] {
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
    
    /// 랩을 계산
    func mergeLaps(data: [HKWorkoutEvent]?) -> [LapSegment] {
        guard let data = data else { return [] }
        
        // - m당 시간 (초) = 총 수영시간 (초) / 총 수영거리
        // - 25m 페이스:  m당 시간(초) * 25
        // - 100m 페이스: m당 시간(초) * 100
        
        print("LapRawData: \(data)")
        
        var lapSegments: [LapSegment] = []
        var laps: [LapSegment.Lap] = []
        var lapCount: Int = 0
        
        for datum in data {
            if datum.type == .segment {
                let newLap = LapSegment(index: lapCount, dateInterval: datum.dateInterval, eventType: datum.type, laps: [])
                lapCount += 1
                lapSegments.append(newLap)
            }
            
            if datum.type == .lap {
                // let poolLength = datum.metadata?["HKMetadataKeyLapLength"] as? Int
                guard let styleNo = datum.metadata?["HKSwimmingStrokeStyle"] as? Int else {
                    print("ERROR: 유효하지 않은 StyleNo.")
                    continue
                }
                let style = HKSwimmingStrokeStyle(rawValue: styleNo)
                let newLap = LapSegment.Lap(style: style, interval: datum.dateInterval)
                laps.append(newLap)
            }
        }
        
        for segmentIndex in 0..<lapSegments.count {
            let currentSegment = lapSegments[segmentIndex]
            var lapsToRemove: [Int] = [] // 제거할 laps의 인덱스를 저장할 배열
            
            for lapIndex in 0..<laps.count {
                let lap = laps[lapIndex]
                if currentSegment.dateInterval.contains(lap.interval.start) && currentSegment.dateInterval.contains(lap.interval.end) {
                    lapSegments[segmentIndex].laps.append(lap)
                    lapsToRemove.append(lapIndex)
                }
            }
            
            // 제거할 Lap들을 laps 배열에서 제거, 역순으로 제거하여 인덱스 문제 방지
            for lapIndex in lapsToRemove.reversed() {
                laps.remove(at: lapIndex)
            }
        }

        print("✅LAPS: \(lapSegments)")
        return lapSegments
        
    }

}
