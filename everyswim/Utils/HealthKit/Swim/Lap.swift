//
//  Lap.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/29.
//

import Foundation
import HealthKit

struct Lap {
    let index: Int
    let dateInterval: DateInterval
    let style: HKSwimmingStrokeStyle?
    let eventType: HKWorkoutEventType?
    let poolLength: Int?
    
    init(index: Int, dateInterval: DateInterval, style: HKSwimmingStrokeStyle?, eventType: HKWorkoutEventType? = nil, poolLength: Int? = nil) {
        self.index = index
        self.dateInterval = dateInterval
        self.style = style
        self.eventType = eventType
        self.poolLength = poolLength
    }
}
