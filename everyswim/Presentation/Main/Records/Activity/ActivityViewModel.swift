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
    var pickerWeeks = [String]()

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
        let today = Date()
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

        self.pickerWeeks = .init()
        self.pickerWeeks.append("이번 주")
        
        // MARK: 지난 주 구하기
        let numberOfWeeks = calendar.component(.weekOfMonth, from: Date()) // 이번주 주차
        
        if numberOfWeeks != 1 {
            for weeknumber in 1..<numberOfWeeks {
                let beforeWeeksFirstDay = calendar.date(byAdding: .day, value: -7 * weeknumber, to: weeksFirstDay)!
                let beforeWeeksLastDay = calendar.date(byAdding: .day, value: -1 * weeknumber, to: weeksFirstDay)!
                
                let weeksFirstDayString = beforeWeeksFirstDay.toString(.dayDotMonth)
                let weeksLastDayString = beforeWeeksLastDay.toString(.dayDotMonth)
                let weeksRangeString = "\(weeksFirstDayString) ~ \(weeksLastDayString)"
                self.pickerWeeks.append("\(weeksRangeString)")
                let weekString = -(weeknumber - numberOfWeeks)
                print("\(month)월 \(weekString)주차는 \(beforeWeeksFirstDay) ~ \(beforeWeeksLastDay)입니다.")
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
