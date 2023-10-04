//
//  Calendar+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/30/23.
//

import Foundation

extension Calendar {
    
    static func getCurrntWeekNumber(from date: Date = Date(), component: Calendar.Component = .weekOfYear) -> Int {
        let Calendar =  Calendar.current
        let currentWeek = Calendar.component(component, from: date)
        return currentWeek
    }
    
    static func isSameWeek(left: Date, right: Date) -> Bool {
        if left.toString(.year) == right.toString(.year) {
            let leftWeek = Calendar.getCurrntWeekNumber(from: left)
            let rightWeek = Calendar.getCurrntWeekNumber(from: right)
            return leftWeek == rightWeek
        }
        
        return false
    }
}
