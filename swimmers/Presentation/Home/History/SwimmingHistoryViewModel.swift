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
        Task { await fetchSwimmingData() }
    }
    
    func fetchSwimmingData() async {
        let swimmingData = await hkManager?.loadSwimmingDataCollection()
        if let swimmingData = swimmingData {
            DispatchQueue.main.async {
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
    func testSwimmingData() async {
        DispatchQueue.main.async {
            self.swimRecords = TestObjects.swimmingData
        }
    }
}

#endif
