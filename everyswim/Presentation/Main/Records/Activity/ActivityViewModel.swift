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
    @Published var weekList: [String] = []
    @Published var selectedSegment: ActivityDataRange = .monthly
    
    
    private let today = Date()
    private let calendar = Calendar.current
    
    var pastDays = [Date]()
    
    @Published var selectedDate: Date = Date()
    
    public var days = [Date]()
    public var weeks = [Date]()
    public var months = [Date]()
    public var year = [Date]()
    
    // MARK: - Pickers Data
    

    init() { 
        updateDate()
    }
    
    func updateDate() {
        getPastDays()
        getPastMonth()
        getPastWeeks()
        getPastYear()
        print("DateDEBUG: Days \(days)")
        print("DateDEBUG: weeks \(weeks)")
        print("DateDEBUG: months \(months)")
        print("DateDEBUG: year \(year)")
    }
    
    func getPastDays(maxCount: Int = 6) {
        self.days = []
        for i in 0...maxCount {
            let day = calendar.date(byAdding: .day, value: -i, to: today) ?? Date()
            self.days.append(day)
        }
    }
    
    private func getPastWeeks(maxCount: Int = 6) {
        self.weeks = []
        for i in 0..<maxCount {
            if let week = calendar.date(byAdding: .weekOfYear, value: -i, to: today),
               let firstDayOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: week)) {
                self.weeks.append(firstDayOfWeek)
            }
        }
    }
    
    private func getPastMonth(maxCount: Int = 6) {
        self.months = []
        for i in 1..<maxCount {
            if let month = calendar.date(byAdding: .month, value: -i, to: today) {
                self.months.append(month)
            }
        }
    }
    private func getPastYear(maxCount: Int = 6) {
        self.year = []
        for i in 1..<maxCount {
            if let lastYear = calendar.date(byAdding: .year, value: -i, to: today) {
                year.append(lastYear)
            } else {
                print("DateDEBUG 날짜 계산 오류")
            }
        }
    }
    
    func getData(_ type: ActivityDataRange) {
        
        var totalData: [SwimMainData]
        
        switch type {
        case .daily:
            totalData = healthStore.getDailyData(date: selectedDate)
        case .weekly:
            totalData = healthStore.getWeeklyData()
        case .monthly:
            totalData = healthStore.getMonthlyData()
        case .yearly:
            totalData = healthStore.getAllData()
        }
        self.presentedData = []
        self.summaryData = self.healthStore.getSummaryData(totalData)
        self.presentedData = totalData
    }
    
    func setSelectedDate(left: String, right: String? = nil) {
        
        switch selectedSegment {
        case .daily:
            return
        case .weekly:
            return
        case .monthly:
            let year = left
            guard let month = right else { return }
            guard let selectedDate = "\(year)-\(month)-01".toDate() else {
                return
            }
            self.selectedDate = selectedDate
        case .yearly:
            let year = left
            guard let selectedDate = "\(year)-01-01".toDate() else {
                return
            }
            self.selectedDate = selectedDate
        }
        
        print("선택됨: \(selectedDate.toString(.fullDotDate))")
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
    
}
