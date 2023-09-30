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
    
    @Published var summaryData: SwimSummaryData?
    @Published var presentedData: [SwimMainData] = []
    @Published var weekList: [String] = []
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
            let totalData = self.healthStore.getDailyData()
            self.summaryData = self.healthStore.getSummaryData(totalData)
            self.presentedData = totalData
        }
    }
    
    private func getWeeklyData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentedData = []
            let totalData = self.healthStore.getWeeklyData()
            self.summaryData = self.healthStore.getSummaryData(totalData)
            self.presentedData = totalData
        }
    }
    
    private func getMonthlyData() {
        self.presentedData = []
        let totalData = healthStore.getMonthlyData()
        self.summaryData = healthStore.getSummaryData(totalData)
        self.presentedData = totalData
    }
    
    private func getlifeTimeData() {
        self.presentedData = []
        let totalData = healthStore.getAllData()
        self.summaryData = healthStore.getSummaryData(totalData)
        self.presentedData = totalData
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
