//
//  ActivityViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import Foundation

final class ActivityViewModel {
    
    @Published var presentedData: [SwimMainData] = []
    @Published var weekList: [String] = []
    @Published var summaryData: SwimSummaryData?
    @Published var selectedSegment: Int = 1
 
    init() {

    }
    
    func getWeeklyData(dateRange: Date) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.summaryData = TestObjects.swimSummaryData
            self.presentedData = TestObjects.swimmingData
        }
    }
    
}

struct SwimSummaryData {
    let count: Int
    let distance: String
    let averagePace: String
    let time: String
}
