//
//  HKCalculator.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import HealthKit

enum HKCalculator {
    
    static func duration(_ interval: TimeInterval, outputType: RelativeTimeType = .hourMinute, unitStyle: DateComponentsFormatter.UnitsStyle = .full) -> String {
        return interval.toRelativeTime(outputType, unitStyle: unitStyle)
    }
    
    static func toRelativeDate(from startDate: Date) -> String {
        // 운동 날짜 및 시간
        let rawLocalDate = startDate.toLocalTime()
        
        let date = rawLocalDate.toString(.dateKr)
        
        return date
    }
    
    static func timeHandler(from startDate: Date, to endDate: Date, stringType: DateToStringType = .timeWithoutSeconds) -> String {
        let start = startDate.toString(stringType)
        let end = endDate.toString(stringType)
        
        return "\(start) ~ \(end)"
    }
    
}
