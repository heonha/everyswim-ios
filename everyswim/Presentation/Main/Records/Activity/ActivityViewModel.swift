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
    private let calendar = Calendar.current
    
    var pastDays = [Date]()
    
    @Published var selectedDate: Date = Date()
    
    // MARK: - Pickers Data
    

    init() { 
        updateDate()
    }
    
    func updateDate() {
        setDatePickerTitle()
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
            let year = left
            guard let month = right else { return }
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
        
        for year in 2020...2023 {
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
