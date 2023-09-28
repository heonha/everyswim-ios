//
//  TimeInterval+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import Foundation

enum RelativeTimeType {
    
    case hourMinute
    case hourMinuteSeconds
    
    var unit: NSCalendar.Unit {
        switch self {
        case .hourMinute:
            return [.hour, .minute]
        case .hourMinuteSeconds:
            return [.hour, .minute, .second]
        }
    }
    
}

extension TimeInterval {
    
    func toRelativeTime(_ type: RelativeTimeType, unitStyle: DateComponentsFormatter.UnitsStyle = .full) -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale.current

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = type.unit
        formatter.unitsStyle = unitStyle
        formatter.calendar = calendar

        let formattedString = formatter.string(from: self)!
        
        return formattedString
    }
    
}
