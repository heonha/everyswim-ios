//
//  ActivityViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import Foundation
import Combine

final class ActivityViewModel: ObservableObject, UseCancellables {

    var cancellables: Set<AnyCancellable> = .init()
    
    private let healthStore = SwimDataStore.shared
    
    @Published var summaryData: SwimSummaryViewModel?
    @Published var presentedData: [SwimMainData] = []
    @Published var selectedSegment: ActivityDataRange = .monthly
    @Published var weekList: [Date] = []

    // MARK: - Picker Objects
    var pickerYears = [String]()
    var pickerMonths = [String]()
    var pickerWeeks = [String]() {
        willSet {
            print("PICKERWEEKS: \(newValue)")
        }
    }

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
    
    @Published var selectedDate: Date = Date()
    
    // MARK: - Pickers Data
    init() {
    }
    
    func updateDate() {
        setYearAndMonthsPickerTitle()
    }
    
    func resetData() {
        self.leftString = ""
        self.rightString = ""
        self.selectedDate = Date()
        self.selectedSegment = .monthly
    }
    
    func resetPickerData() {
        self.leftString = ""
        self.rightString = ""
    }
    
    func getData(_ type: ActivityDataRange) {
        
        var totalData: [SwimMainData]
        
        switch type {
        case .weekly:
            totalData = healthStore.getWeeklyData(date: Date())
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
    
    // 선택한 데이터 불러오기
    func updateSelectedRangesData(left: String, right: String? = nil) {
        
        switch selectedSegment {
        case .weekly:
            let selectedIndex = pickerWeeks
                .firstIndex(of: left)
            
            guard let selectedIndex = selectedIndex else {
                let fetchedData = healthStore.getWeeklyData(date: Date())
                self.presentedData = fetchedData
                return
            }
            
            let selectedDate = weekList[selectedIndex]
            self.selectedDate = selectedDate
            let fetchedData = healthStore.getWeeklyData(date: selectedDate)
            self.presentedData = fetchedData

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
    
    // MARK: - Picker Objects
    
    // 월간, 연간 Picker데이터 셋업
    private func setYearAndMonthsPickerTitle() {
        
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
    
    /// 월의 몇주차인지를 구하고 picker에 추가합니다.
    func setMonthOfWeekNumber() {
        let data = calculateMonthOfWeekNumber()
        self.weekList = .init()
        self.pickerWeeks = .init()
        
        self.weekList = data.weekList
        self.pickerWeeks = data.pickerWeeks
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

}
