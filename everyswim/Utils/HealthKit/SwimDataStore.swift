//
//  SwimDataStore.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/15/23.
//

import SwiftUI
import Combine

final class SwimDataStore {
    
    static let shared = SwimDataStore()
    
    lazy var lastUpdatedDate = CurrentValueSubject<Date?, Never>(Date()) {
        willSet {
            print("SETTED \(newValue)")
        }
    }
    private var swimmingData = CurrentValueSubject<[SwimMainData], Never>([]) {
        willSet {
            self.lastUpdatedDate.send(Date())
        }
    }
    private(set) lazy var swimmingDataPubliser = AnyPublisher(self.swimmingData)

    private init() { }
    
    func refreshSwimData() {
        Task {
            await HealthKitManager.shared.fetchSwimDataFromHealth()
        }
    }
    
    func sendSwimData(_ data: [SwimMainData]) {
        swimmingData.send(data)
    }
    
    func getAllData() -> [SwimMainData] {
        return swimmingData.value
    }
    
    // MARK: - 일간, 주간, 월간, 연간, 요약 데이터 가져오기
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
        return data
    }
    
    func getMonthlyData(_ date: Date = Date()) -> [SwimMainData] {
        let current = date.toString(.yearMonth)
        let data = swimmingData.value
            .filter { current == $0.startDate.toString(.yearMonth) }
        
        return data
    }
    
    func getYearlyData(_ date: Date = Date()) -> [SwimMainData] {
        let current = date.toString(.year)
        
        let data = swimmingData.value
            .filter { current == $0.startDate.toString(.year) }
        
        return data
    }
    
    /// `SummaryData` maker
    /// 세부 기록 표시용 요약 데이터 가져오기
    func getSummaryData(_ data: [SwimMainData]) -> SwimSummaryViewModel {
        let totalData = data
        let count = totalData.count
        
        let duration = totalData
            .reduce(TimeInterval(0)) { $0 + $1.duration }
            .toRelativeTime(.hourMinute, unitStyle: .full)
        
        var distance = totalData
            .reduce(Double(0)) { $0 + $1.unwrappedDistance }
        
        var laps = totalData
            .reduce(Int(0)) { $0 + $1.laps.count }

        var distanceUnit = "m"
        
        var distanceString = ""
        
        if distance > 10000 {
            distance /= 1000
            distanceUnit = "km"
            distanceString = distance.toRoundupString(maxDigit: 1)
        } else {
            distanceString = distance.toRoundupString(maxDigit: 0)
        }
        
        let lapString = laps.description
        
        let summary = SwimSummaryViewModel(count: count,
                                      distance: distanceString,
                                      distanceUnit: distanceUnit,
                                      averagePace: "-'--''",
                                      time: duration,
                                      lap: lapString
        )
        return summary
    }
    
}
