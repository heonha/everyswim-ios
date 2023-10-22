//
//  DatePickerViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import SwiftUI
import Combine
import HealthKit

enum ChangeMonthType {
    case increase
    case decrease
}

final class DatePickerViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    private var cellWidth = Constant.deviceSize.width / 7.2
    
    // MARK: - 달력 데이터
    /// 달력의 날짜 데이터
    @Published var dayInCarendar = [DateValue]()
    /// 달력에서 선택 한 날짜
    @Published var selectedDate = Date()
    /// 달력에서 선택 한 달
    @Published var currentMonth = 0
    /// 월간 기록으로 보기 선택여부
    @Published var isMonthlyRecord = false
    
    /// 모든 달력 이벤트 데이터
    @Published var allEventData = [DatePickerEventData]()
    
    // MARK: - 수영 데이터
    /// 모든  데이터 (수영)
    @Published private var allWorkoutData = [SwimMainData]()
    
    /// 선택한 달의 데이터
    @Published var dataInSelectedMonth = [DatePickerEventData]() {
        willSet {
            print("Set!")
        }
    }
    
    // MARK: - Health Kit
    private var hkManager: HealthKitManager?
    private var hkDataStore = SwimDataStore.shared
    
    
    // MARK: - Init
    init(healthKitManager: HealthKitManager = HealthKitManager()) {
        hkManager = healthKitManager
        observeCurrentMonth()
        dayInCarendar = self.extractDayInMonth()
        observeSwimData()
    }
    
}

extension DatePickerViewModel {


    // MARK: - Appearances
    /// 달력의 날짜 셀 사이즈
    func getSizeForDayCell() -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellWidth)
    }
    
    /// 달력의 날짜 셀 Shadow Radius
    func getShadowRadiusForDayCell() -> CGFloat {
        return getSizeForDayCell().width / 2
    }
    
    /// 달력의 날짜 셀 CornerRadius
    func getCornerRadiusForDayCell(rootViewSize: CGFloat, inset: CGFloat) -> CGFloat {
        let viewRadius = rootViewSize / 2
        let insetValue = inset
        return  viewRadius - insetValue
    }
    
   // MARK: - Calendar Data Handler
    /// 해당 날짜에 데이터가 있는지 여부 확인
    func hasEvent(date: Date) -> Bool {
        let data = dataInSelectedMonth.first { isSameDay($0.eventDate, date) }
        
        if data == nil {
            return false
        } else {
            return true
        }
    }
    
    /// 이벤트 데이터 추출
    func extractDailyData() -> DatePickerEventData? {
        let data = dataInSelectedMonth.first { data in
            return data.eventDate.toString(.date) == selectedDate.toString(.date)
        }

        return data
    }
    
    /// 달력에서 달 변경시 동작
    func refreshCalendar() {
        selectedDate = getCurrentMonth()
        setTargetMonthData()
        isMonthlyRecord = true
    }
    
    // MARK: - Observers
    
    /// 운동 날짜별로 데이터를 할당 합니다.
    private func observeSwimData() {
        hkDataStore
            .swimmingDataPubliser
            .receive(on: DispatchQueue.main)
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.allEventData = self.groupingEventsByDate(tasks: data)
                self.setTargetMonthData()
            }
            .store(in: &cancellables)
    }
    
    /// Current Month를 관찰하고 변경 시 해당 달의 Day 데이터를 가져옵니다.
    private func observeCurrentMonth() {
        self.$currentMonth
            .receive(on: DispatchQueue.main)
            .sink { [weak self] intValue in
                guard let self = self else {return}
                dayInCarendar = extractDayInMonth()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Handlers
    func loadSwimData() {
        // await hkManager?.queryAllSwimmingData()
    }
    
    /// 해당 월의 데이터를 셋팅합니다.
    func setTargetMonthData() {
        self.dataInSelectedMonth.removeAll()
        DispatchQueue.main.async {
            let dataInSelectedMonth = self.allEventData.filter{ self.isSameMonth($0.eventDate, self.selectedDate) }
            self.dataInSelectedMonth = dataInSelectedMonth
            self.sortArray()
        }
    }
    
    /// 선택된 달의 데이터를 내림차순으로 정렬합니다.
    private func sortArray() {
        dataInSelectedMonth.sort { $0.eventDate > $1.eventDate }
    }
    
    /// 날마다의 데이터를 그룹핑합니다.
    private func groupingEventsByDate(tasks: [SwimMainData]) -> [DatePickerEventData] {
        var groupedTasks: [Date: [SwimMainData]] = [:]
        
        for task in tasks {
            let calendar = Calendar.current
            let taskDate = calendar.startOfDay(for: task.startDate)
            
            if var existingTasks = groupedTasks[taskDate] {
                existingTasks.append(task)
                groupedTasks[taskDate] = existingTasks
            } else {
                groupedTasks[taskDate] = [task]
            }
        }
        
        let metaDataArray = groupedTasks.map { date, tasks in
            DatePickerEventData(event: tasks, eventDate: date)
        }
        
        return metaDataArray
    }

    func changeCurrentMonth(_ type: ChangeMonthType) {
        
        switch type {
        case .increase:
            currentMonth += 1
        case .decrease:
            currentMonth -= 1
        }
        isMonthlyRecord = true
        HapticManager.triggerHapticFeedback(style: .light)
    }
    
    
    // MARK: - Calendar Data Handlers
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    private func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)
        
        return components1.year == components2.year && components1.month == components2.month
    }
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: selectedDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func weekdaySetter(_ weekday: Int) -> Weekdays {
        switch weekday {
        case 1...7:
            return Weekdays(rawValue: weekday)!
        default:
            return Weekdays(rawValue: 8)!
        }
    }
    
    /// 해당 달의 day를 추출합니다.
    func extractDayInMonth() -> [DateValue] {
        
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return []
        }
        
        var days = currentMonth
            .getAllDates()
            .compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                let weekday = calendar.component(.weekday, from: date)
                return DateValue(day: day, date: date, weekday: weekdaySetter(weekday))
            }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            let date = Date()
            let weekday = calendar.component(.weekday, from: date)
            days.insert(DateValue(day: -1, date: date, weekday: weekdaySetter(weekday)), at: 0)
        }
        
        return days
    }
    
    
}
