//
//  SwimDataStore.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/15/23.
//

import SwiftUI
import Combine

final class SwimDataStore: ObservableObject {
    
    static let shared = SwimDataStore()
    
    private var swimmingData = CurrentValueSubject<[SwimMainData], Never>([])
    private(set) lazy var swimmingDataPubliser = AnyPublisher(self.swimmingData)

    private init() { }
    
    func sendSwimData(_ data: [SwimMainData]) {
        swimmingData.send(data)
    }
    
    func getAllData() -> [SwimMainData] {
        return swimmingData.value
    }
    
    func getDailyData(date: Date = Date()) -> [SwimMainData] {
        let data = swimmingData.value
            .filter { data in
                date.toString(.dateKr) == data.startDate.toString(.dateKr)
            }
        print(data)
        return data
    }
    
    func getWeeklyData(date: Date = Date()) -> [SwimMainData] {
        let data = swimmingData.value
            .filter { data in
                Calendar.isSameWeek(left: date, right: data.startDate)
            }
        print(data)
        return data
    }
    
    func getMonthlyData(_ date: Date = Date()) -> [SwimMainData] {
        let current = date.toString(.yearMonth)
        let data = swimmingData.value
            .filter { current == $0.startDate.toString(.yearMonth) }
        print(data)
        return data
    }
    
    func getYearlyData(_ date: Date = Date()) -> [SwimMainData] {
        let current = date.toString(.year)
        
        let data = swimmingData.value
            .filter { current == $0.startDate.toString(.year) }
        
        return data
    }
    
    func getSummaryData(_ data: [SwimMainData]) -> SwimSummaryData {
        let totalData = data
        let count = totalData.count
        
        let duration = totalData
            .reduce(TimeInterval(0)) { $0 + $1.duration }
            .toRelativeTime(.hourMinute, unitStyle: .positional)
        
        let distance = totalData
            .reduce(Double(0)) { $0 + $1.unwrappedDistance }
            .toString()
        
        let summary = SwimSummaryData(count: count,
                                      distance: distance,
                                      averagePace: "-'--''",
                                      time: duration)
        print(summary)
        return summary
    }
    
}
