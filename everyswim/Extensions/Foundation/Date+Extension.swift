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
    
    func toStringWeekNumber() -> String {
        let calendar = Calendar.current
        let abc = calendar.component(.weekOfYear, from: self)
        return abc.formattedString()
    }
    
    /// 날짜와 시간을 나눠 출력
    func toStringSplitDateAndTime() -> (date: String, time: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        return (dateFormatter.string(from: self), timeFormatter.string(from: self))
    }

    func toLocalTime() -> Date {
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = self.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
    
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    
    /// 기준일로부터 상대 날짜 반환
    static func relativeDate(from currentDate: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDateString = formatter.localizedString(for: currentDate, relativeTo: Date.now)
        
        return relativeDateString
    }
    
    /// 달력의 모든 날짜 가져오기.
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // Start Date 가져오기
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startDate)!
            return date
        }
    }
    
    static func currentMonthsFirstDay(_ calendar: Calendar = .current) -> Date {
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let monthsFirstDayComponents = DateComponents(year: year, month: month).setGMT9()
        return calendar.date(from: monthsFirstDayComponents)!
    }
        
}
