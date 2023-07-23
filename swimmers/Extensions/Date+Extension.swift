//
//  Date+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import Foundation

extension Date {
    
    func toString(_ type: DateToStringType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.format

        return dateFormatter.string(from: self)
    }
    
    /// 날짜와 시간을 나눠 출력
    func toStringSplitDateAndTime() -> (date: String, time: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        return (dateFormatter.string(from: self), timeFormatter.string(from: self))
    }
    
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    
    func toLocalTime() -> Date {
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = self.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
    
    /// 기준일로부터 상대 날짜 반환
    static func relativeDate(from currentDate: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDateString = formatter.localizedString(for: currentDate, relativeTo: Date.now)
        
        return relativeDateString
    }
        
}
