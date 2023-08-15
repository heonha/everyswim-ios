//
//  HKCalculator.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import HealthKit

enum HKCalculator {
    
    static func duration(_ interval: TimeInterval, outputType: RelativeTimeType = .hourMinute) -> String {
        return interval.toRelativeTime(outputType)
    }
    
    static func toRelativeDate(from startDate: Date) -> String {
        // 운동 날짜 및 시간
        let rawLocalDate = startDate.toLocalTime()
        
        let date = rawLocalDate.toString(.dateKr)
        
        return date
    }
    
    static func timeHandler(from startDate: Date, to endDate: Date) -> String {
        let start = startDate.toString(.timeWithoutSeconds)
        let end = endDate.toString(.timeWithoutSeconds)
        
        return "\(start) ~ \(end)"
    }
    
}
