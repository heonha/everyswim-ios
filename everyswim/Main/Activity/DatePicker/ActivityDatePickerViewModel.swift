//
//  ActivityDatePickerViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 1/7/24.
//

import Foundation
import Combine

final class ActivityDatePickerViewModel: BaseViewModel, IOProtocol {
    
    struct Input {
        let viewWillAppeared: AnyPublisher<Void, Never>
        let dateChanged: AnyPublisher<Date, Never>
        let segmentChanged: AnyPublisher<ActivityDataRange, Never>
    }
    
    struct Output {
        let changePicker: AnyPublisher<ActivityDataRange, Never>
    }
    
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
    
    @Published var weekList: [Date] = []
    
    override init() {
        super.init()
        setMonthOfWeekNumber()
    }
    
    func transform(input: Input) -> Output {
        
        let viewWillAppeared = Publishers
            .CombineLatest(input.dateChanged, input.viewWillAppeared)
            .map { date, _ in
                return date
            }
            .eraseToAnyPublisher()
        
        
        let changePicker = input
            .segmentChanged
            .map { [unowned self] date in
                updateDate()
                return date
            }
            .eraseToAnyPublisher()
        
        return Output(changePicker: changePicker)
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
    
    // 월간, 연간 Picker데이터 셋업
    private func setYearAndMonthsPickerTitle() {
        
        let lessYear: Int = 2016
        guard let currentYear = Date().toString(.year).toInt() else {return}
        guard let currentMonth = Date().toString(.month).toInt() else { return }
        
        for year in lessYear...currentYear {
            pickerYears.append("\(year)")
        }
        
        if currentYear == lessYear {
            for month in 1...currentMonth {
                let monthString = month < 10 ? "0\(month)" : "\(month)"
                pickerMonths.append(monthString)
            }
        } else {
            for month in 1...12 {
                let monthString = month < 10 ? "0\(month)" : "\(month)"
                pickerMonths.append(monthString)
            }
        }
        
    }
    
    func resetData() {
        self.leftString = ""
        self.rightString = ""
        // self.selectedDate = Date()
        // self.selectedSegment = .monthly
    }
    
    func resetPickerData() {
        self.leftString = ""
        self.rightString = ""
    }
    
    func updateDate() {
        setYearAndMonthsPickerTitle()
    }
    
    //     func updateSelectedRangesData(left: String, right: String? = nil) -> Date? {
    //         self.isLoading.send(true)
    //
    //         switch selectedSegment {
    //         case .weekly:
    //             let selectedIndex = right
    //
    //             return selectedDate
    //         case .monthly:
    //             let year = left
    //             let month = month ?? "01"
    //
    //             guard let selectedDate = "\(year)-\(month)-01".toDate() else {
    //                 self.isLoading.send(false)
    //                 return nil
    //             }
    //             self.selectedDate = selectedDate
    //             let fetchedData = healthStore.getMonthlyData(selectedDate)
    //             self.presentedData = fetchedData
    //             self.isLoading.send(false)
    //             return selectedDate
    //         case .yearly:
    //             let year = left
    //             guard let selectedDate = "\(year)-01-01".toDate() else {
    //                 self.isLoading.send(false)
    //                 return nil
    //             }
    //             self.selectedDate = selectedDate
    //             self.presentedData = healthStore.getYearlyData(selectedDate)
    //             self.isLoading.send(false)
    //             return selectedDate
    //         case .total:
    //             return nil
    //         }
    //
    //
    // }
}
