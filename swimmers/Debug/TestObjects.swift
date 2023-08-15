//
//  TestObjects.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

#if DEBUG
import Foundation

enum TestObjects {
    
    static let rings = [
        ChallangeRing(type: .distance, count: 1680, maxCount: 2000),
        ChallangeRing(type: .lap, count: 45, maxCount: 60),
        ChallangeRing(type: .countPerWeek, count: 2, maxCount: 3)
    ]
    
    static let swimmingData = [
        SwimMainData(id: UUID(),
                     duration: 6503,
                     startDate: "2023-07-11-11:30".toDateWithTime()!,
                     endDate: "2023-07-11-12:35".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 1500,
                                                stroke: 460, activeKcal: 500,
                                                restKcal: 120),
                     laps: []),
        
        SwimMainData(id: UUID(),
                     duration: 1234,
                     startDate: "2023-07-15-08:30".toDateWithTime()!,
                     endDate: "2023-07-15-09:23".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 500,
                                                stroke: 460, activeKcal: 250,
                                                restKcal: 100),
                     laps: []),
        
        SwimMainData(id: UUID(),
                     duration: 4567,
                     startDate: "2023-07-13-10:30".toDateWithTime()!,
                     endDate: "2023-07-13-10:50".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 1000,
                                                stroke: 460,
                                                activeKcal: 300,
                                                restKcal: 120),
                     laps: []),
        
        SwimMainData(id: UUID(),
                     duration: 10,
                     startDate: "2023-07-04-09:20".toDateWithTime()!,
                     endDate: "2023-07-04-09:59".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 500,
                                                stroke: 460,
                                                activeKcal: 1000,
                                                restKcal: 98),
                     laps: []),
        
        SwimMainData(id: UUID(),
                     duration: 6503,
                     startDate: "2023-08-11-11:30".toDateWithTime()!,
                     endDate: "2023-08-11-12:35".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 1500,
                                                stroke: 460, activeKcal: 500,
                                                restKcal: 120),
                     laps: []),
        
        SwimMainData(id: UUID(),
                     duration: 1234,
                     startDate: "2023-08-15-08:30".toDateWithTime()!,
                     endDate: "2023-08-15-09:23".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 500,
                                                stroke: 460, activeKcal: 250,
                                                restKcal: 100),
                     laps: []),
        
        SwimMainData(id: UUID(),
                     duration: 4567,
                     startDate: "2023-08-13-10:30".toDateWithTime()!,
                     endDate: "2023-08-13-10:50".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 1000,
                                                stroke: 460,
                                                activeKcal: 300,
                                                restKcal: 120),
                     laps: []),
        SwimMainData(id: UUID(),
                     duration: 1234,
                     startDate: "2023-08-13-12:30".toDateWithTime()!,
                     endDate: "2023-08-13-12:50".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 1212,
                                                stroke: 434,
                                                activeKcal: 234,
                                                restKcal: 566),
                     laps: []),
        
        SwimMainData(id: UUID(),
                     duration: 10,
                     startDate: "2023-08-04-09:20".toDateWithTime()!,
                     endDate: "2023-08-04-09:59".toDateWithTime()!,
                     detail: SwimStatisticsData(distance: 500,
                                                stroke: 460,
                                                activeKcal: 1000,
                                                restKcal: 98),
                     laps: [])
    ]
    
}
#endif


// "yyyy-MM-dd-HH:mm"
// "2023-07-11-11:30"
// "2023-07-11-12:35"
// "2023-07-15-08:30"
// "2023-07-15-09:23"
// "2023-07-04-09:20"
// "2023-07-04-09:59"
