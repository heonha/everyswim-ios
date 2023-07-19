//
//  SwimmingHistoryViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import Combine
import HealthKit

import Foundation

final class SwimmingHistoryViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    
    @Published var swimRecords: [SwimmingData]
    
    init(swimRecords: [SwimmingData]? = nil, healthKitManager: HealthKitManager = HealthKitManager()) {
        self.swimRecords = swimRecords ?? []
        hkManager = healthKitManager
        
        Task {
            await fetchData()
        }
        
    }
    
    func fetchData() async {
    #if targetEnvironment(simulator)
        await testSwimmingData()
    #else
        await fetchSwimmingData()
    #endif
    }
    
    
    private func fetchSwimmingData() async {
        let swimmingData = await hkManager?.loadSwimmingDataCollection()
        if let swimmingData = swimmingData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.swimRecords = swimmingData
            }
        } else {
            return
        }
    }
    
}

#if DEBUG
// Test Stub
extension SwimmingHistoryViewModel {
    private func testSwimmingData() async {
        DispatchQueue.main.async {
            self.swimRecords = TestObjects.swimmingData
        }
    }
}

#endif
