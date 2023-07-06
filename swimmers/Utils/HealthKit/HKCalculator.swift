//
//  HKCalculator.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import HealthKit

enum HKCalculator {
    
    static func duration(_ interval: TimeInterval) {
        // TODO: 초 -> 분으로 -> 60분이상이면 시간으로

    }
    
    static func allStatictics(_ data: [HKQuantityType: HKStatistics]) {
        // TODO: 아래 4개 데이터 핸들링
        // HKQuantityTypeIdentifierDistanceSwimming
        // HKQuantityTypeIdentifierSwimmingStrokeCount
        // HKQuantityTypeIdentifierBasalEnergyBurned
        // HKQuantityTypeIdentifierActiveEnergyBurned
    }

    @available(iOS 16.0, *)
    static func workoutAvtivities(_ data: [HKWorkoutActivity]) {
        // startDate, endDate, duration, allStatstics, statistics, metadata, workoutconfiguration, workoutEvent
    }
    
    static func workoutEvent(_ data: [HKWorkoutEvent]?) {
        guard let data = data else { return }
        //랩타임, 휴식시간, 수영 스타일
//        <_NSConcreteDateInterval: 0x282d62080>
//                (Start Date) 2023-06-04 23:06:00 +0000 +
//                (Duration) 621.031649 seconds =
//                (End Date) 2023-06-04 23:16:21 +0000,
//            HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d62540>
//                (Start Date) 2023-06-04 23:16:03 +0000 +
//                (Duration) 18.785561 seconds =
//                (End Date) 2023-06-04 23:16:21 +0000 {
//             HKSwimmingStrokeStyle = 3;
    }
}

 
