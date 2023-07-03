//
//  HomeViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import HealthKit

final class HomeViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    
    init() {
        hkManager = HealthKitManager()
    }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        
        
    }
    
    
}
