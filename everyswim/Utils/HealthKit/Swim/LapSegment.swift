//
//  LapSegment.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/29.
//

import Foundation
import HealthKit

struct LapSegment {
    var index: Int
    var dateInterval: DateInterval
    var style: HKSwimmingStrokeStyle? // 제거예정
    var eventType: HKWorkoutEventType?
    var poolLength: Int {
        return laps.count * 25
    }
    
    var laps: [Lap]
    
    init(index: Int, dateInterval: DateInterval, style: HKSwimmingStrokeStyle? = nil, eventType: HKWorkoutEventType? = nil, laps: [Lap]) {
        self.index = index
        self.dateInterval = dateInterval
        self.style = style
        self.eventType = eventType
        self.laps = laps
    }
    
    func pace(distance: Int = 25) -> String {
        
        let totalDuration = dateInterval.duration.toInt().toDouble()
        let totalLength = poolLength.toDouble()
        // let dividerLength = distance.toDouble()

        let ddd = totalDuration / totalLength
        let aaa = ddd * distance.toDouble()
        
        let result = aaa.toLapTime(.hourMinuteSeconds)
        
        print("PACE: (\(totalDuration) / \(totalLength)) * \(distance)  = \(aaa)")
        return "\(result)"
    }
    
    struct Lap {
        var style: HKSwimmingStrokeStyle?
        var interval: DateInterval
        var duration: TimeInterval {
            return interval.duration
        }
    }
    
}
