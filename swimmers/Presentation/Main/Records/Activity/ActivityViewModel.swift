//
//  ActivityViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import Foundation
import Combine

final class ActivityViewModel: CombineCancellable {

    var cancellables: Set<AnyCancellable> = .init()
    
    private let healthStore = SwimDataStore.shared
    
    @Published var presentedData: [SwimMainData] = []
    @Published var weekList: [String] = []
    @Published var summaryData: SwimSummaryData?
    @Published var selectedSegment: Int = 1
 
    init() {
        observe()
    }
    

    
    func getData(_ type: ActivityDataRange) {
        
        switch type {
        case .daily:
            getDailyData()
        case .weekly:
            getWeeklyData()
        case .monthly:
            getMonthlyData()
        case .lifetime:
            getlifeTimeData()
        }

    }
    
    private func getDailyData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.summaryData = SwimSummaryData(count: 0, distance: "---", averagePace: "-'--''", time: "0:00")
            self.presentedData = [TestObjects.swimmingData.first!]
        }
    }
    
    private func getWeeklyData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.summaryData = TestObjects.swimSummaryData
            self.presentedData = []
            self.presentedData = TestObjects.swimmingData
        }
    }
    
    private func getMonthlyData() {
        self.summaryData = SwimSummaryData(count: 3, distance: "---", averagePace: "-'--''", time: "0:00")
        self.presentedData = []
    }
    
    private func getlifeTimeData() {
        let totalData = healthStore.swimmingData.value
        self.presentedData = totalData
        let duration = totalData.reduce(TimeInterval(0)) { partialResult, data in
            partialResult + data.duration
        }
        
        let distance = totalData.reduce(Double(0)) { partialResult, data in
            partialResult + data.unwrappedDistance
        }
        
        self.summaryData = SwimSummaryData(count: totalData.count,
                                           distance: distance.toString(),
                                           averagePace: "-'--''",
                                           time: duration.toRelativeTime(.hourMinuteSeconds, unitStyle: .positional))
    }
    
    func observe() {
    }
    
}

enum ActivityDataRange {
    case daily
    case weekly
    case monthly
    case lifetime
}

struct SwimSummaryData {
    let count: Int
    let distance: String
    let averagePace: String
    let time: String
}
