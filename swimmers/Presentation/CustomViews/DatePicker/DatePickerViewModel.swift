//
//  DatePickerViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import SwiftUI

class DatePickerViewModel: ObservableObject {
    
    @Published var currentDate = Date()    
    @Published var currentMonth = 0

    func changeMonth() {
        currentDate = getCurrentMonth()
    }
    
    // 날짜 체크하기
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // 연도와 월을 추출하기.
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // 기존 월 가져오기
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return Date()
        }
        
        print("Current Month: \(currentMonth)")
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        // 기존 월 가져오기
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return []
        }
        
        // 일자 가져오기
        var days = currentMonth
            .getAllDates()
            .compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                return DateValue(day: day, date: date)
            }
        
        // 주간 첫번째 요일 찾기.
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}
