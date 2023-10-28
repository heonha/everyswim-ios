//
//  ActivityViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import Foundation
import Combine

final class ActivityViewModel: ObservableObject, CombineCancellable {

    var cancellables: Set<AnyCancellable> = .init()
    
    private let healthStore = SwimDataStore.shared
    
    @Published var summaryData: SwimSummaryData?
    @Published var presentedData: [SwimMainData] = []
    @Published var selectedSegment: ActivityDataRange = .monthly
    @Published var weekList: [String] = []

    // MARK: - Picker Objects
    var pickerYears = [String]()
    var pickerMonths = [String]()
    
    var leftString = "" {
        willSet {
            print("LEFT: \(newValue)")
        }
    }
    var rightString: String = "" {
        willSet {
            print("RIGHT: \(newValue)")
        }
    }
    
    private let today = Date()
    
    var pastDays = [Date]()
    
    @Published var selectedDate: Date = Date()
    
    // MARK: - Pickers Data
    init() {

    }
    
    func updateDate() {
        setDatePickerTitle()
    }
    
    func calculateMonthOfWeekNumber() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: Date())
        let todayComponents = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0).setGMT9()
        
        guard let todaydate = calendar.date(from: todayComponents) else { return }
        
        // MARK: 이번 주 구하기
        let weekday = calendar.component(.weekday, from: todaydate) // 이번주 요일
        let distanceTodayToSunday: Int = -(weekday - 1)
        let distanceTodayToSaturday: Int = weekday - 7
        
        let weeksFirstDay = calendar.date(byAdding: .day, value: distanceTodayToSunday, to: today)!
        let weeksLastDay = calendar.date(byAdding: .day, value: distanceTodayToSaturday, to: today)!
        
        print("이번주의 일요일은 \(weeksFirstDay)입니다.")
        print("이번주의 토요일은 \(weeksLastDay)입니다.")
        
        // MARK: 지난 주 구하기
        let numberOfWeeks = calendar.component(.weekOfMonth, from: Date()) // 이번주 주차
        
        if numberOfWeeks != 1 {
            for weeknumber in 1..<numberOfWeeks {
                let beforeWeeksFirstDay = calendar.date(byAdding: .day, value: -7 * weeknumber, to: weeksFirstDay)!
                let beforeWeeksLastDay = calendar.date(byAdding: .day, value: -1 * weeknumber, to: weeksFirstDay)!
                
                let weekString = -(weeknumber - numberOfWeeks)
                print("\(weekString)주는 \(beforeWeeksFirstDay) ~ \(beforeWeeksLastDay)입니다.")
            }
        }
        
    }
    
    func extractGPTWeekDay() {
        
        // 현재 날짜를 얻습니다.
        let currentDate = Date()

        // Calendar 객체를 생성합니다.
        let calendar = Calendar.current

        // Calendar의 시작 요일을 고려하여 현재 날짜의 연도와 월을 가져옵니다.
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)

        // Calendar의 시작 요일을 가져옵니다.
        let firstWeekday = calendar.firstWeekday

        // 이번 달의 첫 번째 날짜를 구합니다.
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        if let firstDayOfTheMonth = calendar.date(from: dateComponents) {
            // 이번 달의 주차를 계산합니다.
            let weekNumber = calendar.component(.weekOfMonth, from: firstDayOfTheMonth)
            
            // 각 주차의 시작과 끝 날짜를 계산합니다.
            for week in 1...5 {
                dateComponents.weekday = firstWeekday
                dateComponents.weekOfMonth = week
                
                if let weekStartDate = calendar.date(from: dateComponents) {
                    let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate)
                    // 각 주차의 범위를 출력합니다.
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM월 dd일"
                    let startDateString = dateFormatter.string(from: weekStartDate)
                    let endDateString = dateFormatter.string(from: weekEndDate!)
                    
                    print("\(year)-\(String(format: "%02d", month))월의 \(week)주차 (\(startDateString) ~ \(endDateString))")
                }
            }
        }

    }
    
    func resetData() {
        self.leftString = ""
        self.rightString = ""
        self.selectedDate = Date()
        self.selectedSegment = .monthly
    }
    
    func getData(_ type: ActivityDataRange) {
        
        var totalData: [SwimMainData]
        
        switch type {
        case .weekly:
            totalData = healthStore.getWeeklyData()
        case .monthly:
            totalData = healthStore.getMonthlyData()
        case .yearly:
            totalData = healthStore.getYearlyData()
        case .total:
            totalData = healthStore.getAllData()
        }
        self.presentedData = []
        setSummaryData()
        self.presentedData = totalData
    }
    
    func setSummaryData() {
        $presentedData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.summaryData = self?.healthStore.getSummaryData(data)
            }
            .store(in: &cancellables)
    }
    
    func setSelectedDate(left: String, right: String? = nil) {
        
        switch selectedSegment {
        case .weekly:
            return
        case .monthly:
            let year = leftString
            let month = rightString
            
            guard let selectedDate = "\(year)-\(month)-01".toDate() else {
                return
            }
            
            self.selectedDate = selectedDate
            let fetchedData = healthStore.getMonthlyData(selectedDate)
            self.presentedData = fetchedData
        case .yearly:
            let year = left
            guard let selectedDate = "\(year)-01-01".toDate() else {
                return
            }
            self.selectedDate = selectedDate
            self.presentedData = healthStore.getYearlyData(selectedDate)
        case .total:
            return
        }
        
    }
    
    func convertAllDataToYear() {
        let allData = self.healthStore.getAllData()
        let recordsDate = allData.map { $0.startDate }
        
        let years = recordsDate.map { date in
            date.toString(.year)
        }
        
        let months = recordsDate.map { date in
            date.toString(.yearMonth)
        }
        
        print("YEARS: \(years)")
        print("MONTHS: \(months)")
    }
    
    // MARK: - Picker Objects
    private func setDatePickerTitle() {
        
        for year in 2016...2023 {
            pickerYears.append("\(year)")
        }
        
        for month in 1...12 {
            if month < 10 {
                pickerMonths.append("0\(month)")
            } else {
                pickerMonths.append("\(month)")
            }
        }
        
    }
    
}
