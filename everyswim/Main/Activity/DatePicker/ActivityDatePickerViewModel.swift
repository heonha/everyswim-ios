//
//  ActivityDatePickerViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 1/7/24.
//

import Foundation
import Combine

final class ActivityDatePickerViewModel: BaseViewModel, IOProtocol {
    
    private let healthStore = SwimDataStore.shared
    var weekList = CurrentValueSubject<[Date], Never>([])
    var components = CurrentValueSubject<[String], Never>([""])
    var rows = CurrentValueSubject<[[String]], Never>([[""], [""]])
    private var range: ActivityDataRange?
    
    var selectedLeftRow: String = ""
    var selectedRightRow: String?
    
    struct Input {

    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func getDateRange() -> ActivityDataRange? {
        return self.range
    }
    
    func getPickerComponents(_ range: ActivityDataRange) {
        self.range = range
        switch range {
        case .weekly:
            self.setMonthOfWeekNumber()
        case .monthly:
            self.setYearAndMonthsPickerTitle()
        case .yearly:
            self.setYear()
        case .total:
            return
        }
        
    }
    
    private func setYear() {
        let components = ["year"]
        var rows: [[String]] = [[]]
        let currentYear = Date().toString(.year).toInt() ?? 2023
        
        for year in 2016...currentYear {
            rows[0].append("\(year)")
        }

        self.components.send(components)
        self.rows.send(rows)
    }

    private func setYearAndMonthsPickerTitle() {
        let components = ["year", "month"]
        var rows: [[String]] = [[], []]
        
        let currentYear = Date().toString(.year).toInt() ?? 2023

        for year in 2016...currentYear {
            rows[0].append("\(year)")
        }
        
        for month in 1...12 {
            if month < 10 {
                rows[1].append("0\(month)")
            } else {
                rows[1].append("\(month)")
            }
        }
        
        self.components.send(components)
        self.rows.send(rows)
    }
    
    /// 월의 몇주차인지를 구하고 picker에 추가합니다.
    func setMonthOfWeekNumber() {
        let data = calculateMonthOfWeekNumber()
        self.weekList.send(data.weekList)
        self.rows.send([data.pickerWeeks])
    }
    
    /// 오늘이 월의 몇주차인지 계산하고 지난 주차와 이번 주를 반환합니다.
    private func calculateMonthOfWeekNumber() -> (pickerWeeks: [String], weekList: [Date]) {
        let today = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: Date())
        let todayComponents = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0).setGMT9()
        
        var pickerWeeks: [String] = []
        var weekList: [Date] = []
        
        guard let todaydate = calendar.date(from: todayComponents) else { return (pickerWeeks: pickerWeeks, weekList: weekList) }
        
        // MARK: 이번 주 구하기
        let weekday = calendar.component(.weekday, from: todaydate) // 이번주 요일
        let distanceTodayToSunday: Int = -(weekday - 1)
        let weeksFirstDay = calendar.date(byAdding: .day, value: distanceTodayToSunday, to: today)!

        weekList.append(weeksFirstDay)
        pickerWeeks.append("이번 주")
        
        // MARK: 지난 주 구하기
        let numberOfWeeks = calendar.component(.weekOfMonth, from: Date()) // 이번주 주차
        if numberOfWeeks != 1 {
            
            for weeknumber in 1..<numberOfWeeks {
                let beforeWeeksFirstDay = calendar.date(byAdding: .day, value: -7 * weeknumber, to: weeksFirstDay)!
                let beforeWeeksLastDay = calendar.date(byAdding: .day, value: -1 * weeknumber, to: weeksFirstDay)!
                
                let weeksFirstDayString = beforeWeeksFirstDay.toString(.dayDotMonth)
                let weeksLastDayString = beforeWeeksLastDay.toString(.dayDotMonth)
                let weeksRangeString = "\(weeksFirstDayString) ~ \(weeksLastDayString)"
                
                let weekString = -(weeknumber - numberOfWeeks)
                pickerWeeks.append("\(weekString)주차 (\(weeksRangeString))")
                weekList.append(beforeWeeksFirstDay)
            }
            pickerWeeks.reverse()
            weekList.reverse()
        }
        
        return (pickerWeeks: pickerWeeks, weekList: weekList)
        
    }
    
    func updateSelectedRangesData(selectedDataRange: ActivityDataRange, left: String, right: String? = nil) -> ActivityDatePickerViewData? {
        
        switch selectedDataRange {
        case .weekly:
            let selectedIndex = rows.value[0].firstIndex(of: left)

            guard let selectedIndex = selectedIndex else {
                print("selected Index가 nil 입니다.")
                return nil
            }
            let selectedLabel = rows.value[0][selectedIndex]
            let selectedDate = weekList.value[selectedIndex]
            return ActivityDatePickerViewData(range: selectedDataRange, date: selectedDate, titleLabel: "\(selectedLabel)")
            
        case .monthly:
            let year = left
            let month = right!
        
            guard let selectedDate = "\(year)-\(month)-01".toDate() else {
                print("selected Date가 nil 입니다.")
                return nil
            }
            return ActivityDatePickerViewData(range: selectedDataRange, date: selectedDate, titleLabel: "\(year)년 \(month)월")
            
        case .yearly:
            let year = left
            guard let selectedDate = "\(year)-01-01".toDate() else {
                print("selected Date가 nil 입니다.")
                return nil
            }
            return ActivityDatePickerViewData(range: selectedDataRange, date: selectedDate, titleLabel: "\(year)년")
            
        case .total:
            return nil
        }
        
    }

}
