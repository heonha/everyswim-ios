//
//  EventDatePickerViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import SwiftUI
import Combine
import HealthKit

final class EventDatePickerViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentDate = Date()
    @Published var currentMonth = 0
    @Published var isMonthlyRecord = false

    @Published var workouts: [DatePickerMetaData] = []
    @Published var dateMetadata: [DatePickerMetaData] = []
    @Published private var swimdata: [SwimMainData] = []
    
    private var hkManager: HealthKitManager?
    
    init(healthKitManager: HealthKitManager = HealthKitManager()) {
        self.hkManager = healthKitManager
    }
    
}

extension EventDatePickerViewModel {
    
    func changeMonth() {
        currentDate = getCurrentMonth()
        isMonthlyRecord = true
        setTargetMonthData()
    }
    
    private func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)
                
        return components1.year == components2.year && components1.month == components2.month
    }
    
    func subscribeSwimData() async {
        await hkManager?.loadSwimmingDataCollection()
        SwimDataStore.shared.swimmingData
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.dateMetadata = self.groupEventsByDate(tasks: data)
                self.setTargetMonthData()
            }
            .store(in: &cancellables)
    }
    
    private func setTargetMonthData() {
        DispatchQueue.main.async {
            self.workouts = self.dateMetadata.filter { metadata in
                self.isSameMonth(metadata.taskDate, self.currentDate)
            }
            
            print("계산결과: \(self.currentDate.toString(.dayDotMonth)) \(self.workouts.count)")

            self.sortArray()
        }
    }
    
    private func sortArray() {
        workouts.sort { $0.taskDate > $1.taskDate }
    }
    
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return Date()
        }
        
        print("Current Month: \(currentMonth)")
        
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
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
            return []
        }
        
        var days = currentMonth
            .getAllDates()
            .compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                let weekday = calendar.component(.weekday, from: date)
                return DateValue(day: day, date: date, weekDay: weekdaySetter(weekday))
            }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            let date = Date()
            let weekday = calendar.component(.weekday, from: date)
            days.insert(DateValue(day: -1, date: date, weekDay: weekdaySetter(weekday)), at: 0)
        }
        
        return days
    }
    
    private func groupEventsByDate(tasks: [SwimMainData]) -> [DatePickerMetaData] {
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
            DatePickerMetaData(event: tasks, taskDate: date)
        }

        return metaDataArray
    }
    
}
