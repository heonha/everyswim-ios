//
//  HomeViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import Combine
import HealthKit

final class HomeViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    
    private var kcals: [HealthStatus] = []
    private var stroke: [HealthStatus] = []
    
    @Published var swimRecords: [SwimmingData] = []
    @Published var kcalPerWeek: Double = 0.0
    @Published var strokePerMonth: Double = 0.0
    
    init() {
        hkManager = HealthKitManager()
    }
    
    func fetchSwimmingData() async {
        let swimmingData = await hkManager?.loadSwimmingDataCollection()
        if let swimmingData = swimmingData {
            DispatchQueue.main.async {
                self.swimRecords = swimmingData
            }
        } else {
            return
        }
    }
        
    func loadHealthCollection() async {
        self.kcals = []
        self.stroke = []
        
        print("DEBUG: 헬스 데이터 가져오기")
        guard let hkManager = hkManager else { return }
        
        print("DEBUG: 인증을 확인합니다")
        
        let isAuthed = await hkManager.requestAuthorization()
        
        if isAuthed {
            hkManager.getHealthData(dataType: .kcal, queryRange: .week) { result in
                if let statCollection = result {
                    print("업데이트 \(statCollection)")
                    self.updateUIFromStatistics(statCollection, type: .kcal, queryRange: .week)
                } else {
                    print("Collection 가져오기실패")
                }
            }
        } else {
            print("DEBUG: Health 일반 데이터 권한이 거부되었습니다.")
        }
    }
    
    func updateUIFromStatistics(_ statCollection: HKStatisticsCollection,
                                type: HKQueryDataType,
                                queryRange: HKDateType) {
        
        guard let startDate = Calendar.current.date(byAdding: .day,
                                                    value: queryRange.value(),
                                                    to: Date()) else { return }
        let endDate = Date()
        
        print("Debug: \(#function) StatCollection만들기 시작")
        /// 시작 날짜부터 종료 날짜까지의 모든 시간 간격에 대한 통계 개체를 열거합니다.
        statCollection.enumerateStatistics(from: startDate, to: endDate) { statCollection, _ in
            
            switch type {
            case .kcal:
                var count = statCollection.sumQuantity()?.doubleValue(for: .kilocalorie())
                guard let count = count else { return }
                let data = HealthStatus(count: count, date: statCollection.startDate)
                print("Debug: kcal가 완료되었습니다. \(data)")
                self.kcals.append(data)
                
                DispatchQueue.main.async {
                    self.kcalPerWeek = self.kcals.reduce(0) { partialResult, kcal in
                        partialResult + kcal.count
                    }
                }
                print("DEBUG: Kcal per Week\(self.kcalPerWeek)")
            default:
                print("DEBUG: \(#function) 알수없는 오류. default에 도달했습니다.")
                return
            }
        }
    }
    
}


// duration: 3254.731590986252
// allStatistics:
// [HKQuantityTypeIdentifierDistanceSwimming:
//     <<HKStatistics: 0x2816f0820> Statistics on HKQuantityTypeIdentifierDistanceSwimming (2023-06-04 23:05:59 +0000 - 2023-06-05 00:00:14 +0000) over sources ((null))>,
//     HKQuantityTypeIdentifierSwimmingStrokeCount: <<HKStatistics: 0x2816f08f0> Statistics on HKQuantityTypeIdentifierSwimmingStrokeCount (2023-06-04 23:05:59 +0000 -  2023-06-05 00:00:14 +0000) over sources ((null))>,
//     HKQuantityTypeIdentifierBasalEnergyBurned: <<HKStatistics: 0x2816f0a90> Statistics on HKQuantityTypeIdentifierBasalEnergyBurned (2023-06-04 23:05:59 +0000 -  2023-06-05 00:00:14 +0000) over sources ((null))>,
//     HKQuantityTypeIdentifierActiveEnergyB
//     urned: <<HKStatistics: 0x2816f0b60> Statistics on HKQuantityTypeIdentifierActiveEnergyBurned (2023-06-04 23:05:59 +0000 - 2023-06-05 00:00:14 +0000) over sources  ((null))>]
// workoutActivities: [<HKWorkoutActivity 9B9EF1D0-42FD-4B5E-92F8-1D505D5CE5EC <HKWorkoutConfiguration:0x2809d54a0 activity:HKWorkoutActivityTypeSwimming  location:outdoors swimming location:pool lap length:25 m> 2023-06-04 23:05:59 +0000 2023-06-05 00:00:14 +0000>]
// workoutActivityType: HKWorkoutActivityType(rawValue: 46)
// workoutEvents: Optional([HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d62080> (Start Date) 2023-06-04 23:06:00 +0000 + (Duration) 621.031649 seconds =  (End Date) 2023-06-04 23:16:21 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d62540> (Start Date) 2023-06-04 23:16:03 +0000 + (Duration)  18.785561 seconds = (End Date) 2023-06-04 23:16:21 +0000 {
//     HKSwimmingStrokeStyle = 3;
// },
//
// HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d625a0> (Start Date) 2023-06-04 23:17:33 +0000 + (Duration) 31.524181 seconds = (End Date) 2023-06-04  23:18:04 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d62620> (Start Date) 2023-06-04 23:17:33 +0000 + (Duration) 31.524181 seconds = (End Date) 2023-06-04  23:18:04 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d62660> (Start Date) 2023-06-04 23:18:25 +0000 + (Duration) 38.169073 seconds = (End  Date) 2023-06-04 23:19:03 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d62600> (Start Date) 2023-06-04 23:18:25 +0000 + (Duration) 38.169073 seconds = (End Date) 2023-06-04  23:19:03 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d626e0> (Start Date) 2023-06-04 23:19:49 +0000 + (Duration) 14.534096 seconds = (End  Date) 2023-06-04 23:20:04 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d62740> (Start Date) 2023-06-04 23:19:49 +0000 + (Duration) 38.461768 seconds = (End Date) 2023-06-04  23:20:28 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d62780> (Start Date) 2023-06-04 23:20:10 +0000 + (Duration) 18.203081 seconds = (End  Date) 2023-06-04 23:20:28 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d629a0> (Start Date) 2023-06-04 23:21:39 +0000 + (Duration) 41.486095 seconds = (End Date) 2023-06-04  23:22:20 +0000 {
//     HKSwimmingStrokeStyle = 3;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d62b20> (Start Date) 2023-06-04 23:21:39 +0000 + (Duration) 53.803628 seconds = (End Date) 2023-06-04  23:22:33 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d62b80> (Start Date) 2023-06-04 23:22:21 +0000 + (Duration) 11.276112 seconds = (End  Date) 2023-06-04 23:22:33 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d62c00> (Start Date) 2023-06-04 23:23:03 +0000 + (Duration) 42.869146 seconds = (End Date) 2023-06-04  23:23:46 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d62c60> (Start Date) 2023-06-04 23:23:03 +0000 + (Duration) 42.869146 seconds = (End Date) 2023-06-04  23:23:46 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d63300> (Start Date) 2023-06-04 23:25:08 +0000 + (Duration) 15.085003 seconds = (End  Date) 2023-06-04 23:25:23 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d63340> (Start Date) 2023-06-04 23:25:08 +0000 + (Duration) 72.507750 seconds = (End Date) 2023-06-04  23:26:21 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d633a0> (Start Date) 2023-06-04 23:25:32 +0000 + (Duration) 48.531872 seconds = (End  Date) 2023-06-04 23:26:21 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d63460> (Start Date) 2023-06-04 23:27:01 +0000 + (Duration) 34.289119 seconds = (End Date) 2023-06-04  23:27:35 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d63520> (Start Date) 2023-06-04 23:27:01 +0000 + (Duration) 34.289119 seconds = (End Date) 2023-06-04  23:27:35 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d634c0> (Start Date) 2023-06-04 23:28:59 +0000 + (Duration) 34.930590 seconds = (End  Date) 2023-06-04 23:29:34 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d63580> (Start Date) 2023-06-04 23:28:59 +0000 + (Duration) 34.930590 seconds = (End Date) 2023-06-04  23:29:34 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d63680> (Start Date) 2023-06-04 23:30:20 +0000 + (Duration) 33.727744 seconds = (End  Date) 2023-06-04 23:30:54 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d633e0> (Start Date) 2023-06-04 23:30:20 +0000 + (Duration) 33.727744 seconds = (End Date) 2023-06-04  23:30:54 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d63740> (Start Date) 2023-06-04 23:31:11 +0000 + (Duration) 39.541191 seconds = (End  Date) 2023-06-04 23:31:51 +0000 {
//     HKSwimmingStrokeStyle = 3;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d63880> (Start Date) 2023-06-04 23:31:11 +0000 + (Duration) 39.541191 seconds = (End Date) 2023-06-04  23:31:51 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d63900> (Start Date) 2023-06-04 23:32:30 +0000 + (Duration) 48.882447 seconds = (End  Date) 2023-06-04 23:33:19 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d63780> (Start Date) 2023-06-04 23:32:30 +0000 + (Duration) 48.882447 seconds = (End Date) 2023-06-04  23:33:19 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d63ac0> (Start Date) 2023-06-04 23:35:07 +0000 + (Duration) 42.347853 seconds = (End  Date) 2023-06-04 23:35:49 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d637e0> (Start Date) 2023-06-04 23:35:07 +0000 + (Duration) 79.904602 seconds = (End Date) 2023-06-04  23:36:27 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d63e80> (Start Date) 2023-06-04 23:35:54 +0000 + (Duration) 32.615227 seconds = (End  Date) 2023-06-04 23:36:27 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d6b480> (Start Date) 2023-06-04 23:38:38 +0000 + (Duration) 48.341583 seconds = (End Date) 2023-06-04  23:39:26 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d680a0> (Start Date) 2023-06-04 23:38:38 +0000 + (Duration) 96.482671 seconds = (End Date) 2023-06-04  23:40:14 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d69160> (Start Date) 2023-06-04 23:39:34 +0000 + (Duration) 40.684590 seconds = (End  Date) 2023-06-04 23:40:14 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d6a240> (Start Date) 2023-06-04 23:44:10 +0000 + (Duration) 30.540489 seconds = (End Date) 2023-06-04  23:44:41 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d6a8e0> (Start Date) 2023-06-04 23:44:10 +0000 + (Duration) 30.540489 seconds = (End Date) 2023-06-04  23:44:41 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d6ba60> (Start Date) 2023-06-04 23:45:07 +0000 + (Duration) 47.679912 seconds = (End  Date) 2023-06-04 23:45:55 +0000 {
//     HKSwimmingStrokeStyle = 2;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d6b940> (Start Date) 2023-06-04 23:45:07 +0000 + (Duration) 47.679912 seconds = (End Date) 2023-06-04  23:45:55 +0000, HKWorkoutEventTypeLap, <_NSConcreteDateInterval: 0x282d6b880> (Start Date) 2023-06-04 23:58:33 +0000 + (Duration) 27.018217 seconds = (End  Date) 2023-06-04 23:59:00 +0000 {
//     HKSwimmingStrokeStyle = 5;
// },
//
// HKWorkoutEventTypeSegment, <_NSConcreteDateInterval: 0x282d6b6c0> (Start Date) 2023-06-04 23:58:33 +0000 + (Duration) 27.018217 seconds = (End Date) 2023-06-04  23:59:00 +0000])
//
//

enum StrokeStyle {
    
    case backstroke
    case breaststroke
    case butterfly
    case freestyle
    case mixed
    case kickboard
    case unknown
    
    func name() -> String {
        switch self {
        case .backstroke:
            return "배영"
        case .breaststroke:
            return "평영"
        case .butterfly:
            return "접영"
        case .freestyle:
            return "자유형"
        case .mixed:
            return "혼영"
        case .kickboard:
            return "보드영"
        case .unknown:
            return "알수없음영"
        }
    }
    
}
