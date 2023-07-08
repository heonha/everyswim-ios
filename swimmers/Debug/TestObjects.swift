//
//  TestObjects.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

#if DEBUG
import Foundation

class TestObjects {
    
    static let rings = [
        ChallangeRing(type: .distance, count: 1680, maxCount: 2000),
        ChallangeRing(type: .lap, count: 45, maxCount: 60),
        ChallangeRing(type: .countPerWeek, count: 2, maxCount: 3)
    ]
    
    static let swimmingData = [
        SwimmingData(id: UUID(), duration: 6503, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460),
        SwimmingData(id: UUID(), duration: 1234, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460),
        SwimmingData(id: UUID(), duration: 4567, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460),
        SwimmingData(id: UUID(), duration: 10, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460)
    ]
    
}
#endif
