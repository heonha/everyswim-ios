//
//  DatePickerViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import SwiftUI
import Combine
import HealthKit

final class DatePickerViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedDate = Date()
    @Published var currentMonth = 0 {
        didSet {
            dayInCarendar = self.extractDayInMonth()
        }
    }
    @Published var isMonthlyRecord = false
    private var cellWidth = Constant.deviceSize.width / 7.2
    
    @Published private var allWorkoutData: [SwimMainData] = []
    @Published var allEventData: [DatePickerEventData] = []
    
    @Published var dataInSelectedMonth: [DatePickerEventData] = []
    @Published var dayInCarendar: [DateValue] = []
    
    private var hkManager: HealthKitManager?
    
    init(healthKitManager: HealthKitManager = HealthKitManager()) {
        hkManager = healthKitManager
        dayInCarendar = self.extractDayInMonth()
    }
    
}

extension DatePickerViewModel {
    
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
    
    func changeMonth() {
        selectedDate = getCurrentMonth()
        isMonthlyRecord = true
        self.dataInSelectedMonth = []
        setTargetMonthData()
    }
    
    func getCellSize() -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellWidth)
    }
    
    func getShadowRadiusSize() -> CGFloat {
        return getCellSize().width / 2
    }
    
    func getDayViewRadius(rootViewSize: CGFloat, inset: CGFloat) -> CGFloat {
        let viewRadius = rootViewSize / 2
        let insetValue = inset
        return  viewRadius - insetValue
    }
    
    func subscribeSwimData() async {
        await hkManager?.loadSwimmingDataCollection()
        
        SwimDataStore.shared
            .swimmingDataPubliser
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.allEventData = self.groupingEventsByDate(tasks: data)
                self.setTargetMonthData()
            }
            .store(in: &cancellables)
    }
    
    private func setTargetMonthData() {
        DispatchQueue.main.async {
            self.dataInSelectedMonth = self.allEventData.filter { metadata in
                self.isSameMonth(metadata.eventDate, self.selectedDate)
            }
            
            self.sortArray()
        }
    }
    
    private func sortArray() {
        dataInSelectedMonth.sort { $0.eventDate > $1.eventDate }
    }
    
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
    
}
