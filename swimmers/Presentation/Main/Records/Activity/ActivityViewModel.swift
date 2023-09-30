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
 
    init() { }
    
    func getData(_ type: ActivityDataRange) {
        
        var totalData: [SwimMainData]
        
        switch type {
        case .daily:
            totalData = healthStore.getDailyData()
        case .weekly:
            totalData = healthStore.getWeeklyData()
        case .monthly:
            totalData = healthStore.getMonthlyData()
        case .lifetime:
            totalData = healthStore.getAllData()
        }
        self.presentedData = []
        self.summaryData = self.healthStore.getSummaryData(totalData)
        self.presentedData = totalData
    }
    
}
