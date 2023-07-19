//
//  HKCalculator.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import HealthKit

enum HKCalculator {
    
    static func duration(_ interval: TimeInterval) -> String {
        return interval.stringFromTimeInterval()
    }
    
    static func dateHandeler(from startDate: Date) -> String {
        // 운동 날짜 및 시간
        let rawLocalDate = startDate.toLocalTime()
        
        let date = rawLocalDate.toStringYYYYMMddKr()
        
        return date
    }
    
    static func timeHandler(from startDate: Date, to endDate: Date) -> String {
        let start = startDate.toStringOnlyTime()
        let end = endDate.toStringOnlyTime()
        
        return "\(start) ~ \(end)"
    }
    
}
