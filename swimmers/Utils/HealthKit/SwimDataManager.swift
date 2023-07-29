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
    
    
    func createSwimMainData(_ workouts: [HKWorkout]) -> [SwimMainData] {
        var swimmingData: [SwimMainData] = []

        for workout in workouts {
            
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
    
    
    @available (iOS 16.0, *)
    func allStatDataHandler(_ record: HKWorkout) -> SwimStatisticsData {
        
        let allStat = record.allStatistics
        print("Key Allstat \(allStat)")
        print("Key Allstat \(allStat)")
        
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
    
    
    func mergeLaps(data: [HKWorkoutEvent]?) -> [Lap] {
        guard let data = data else { return [] }
        
        var laps: [Lap] = []
        var lapCount: Int = 0
        
        for datum in data {
            if datum.type == .lap {
                lapCount += 1
                
                if let styleNo = datum.metadata?["HKSwimmingStrokeStyle"] as? Int {
                    let style = HKSwimmingStrokeStyle(rawValue: styleNo)
                    let newLap = Lap(index: lapCount, dateInterval: datum.dateInterval, style: style)
                    laps.append(newLap)
                } else {
                    let newLap = Lap(index: lapCount, dateInterval: datum.dateInterval, style: nil)
                    laps.append(newLap)
                }
            } else {
                continue
            }
        }
        
        return laps
        
    }

    
}

