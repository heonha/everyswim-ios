//
//  SwimmingHistoryViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import Combine
import HealthKit

enum SortType: String {
    case date
    case distance
    case duration
    case kcal
    
    var title: String {
        switch self {
        case .date:
            return "최근 순"
        case .distance:
            return "거리"
        case .duration:
            return "운동시간"
        case .kcal:
            return "칼로리"
        }
    }
}

final class SwimmingHistoryViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    
    @Published var swimRecords: [SwimmingData]
    @AppStorage("recordSort") var sort: SortType = .date
    
    init(swimRecords: [SwimmingData]? = nil, healthKitManager: HealthKitManager = HealthKitManager()) {
        self.swimRecords = swimRecords ?? []
        hkManager = healthKitManager
        
        Task {
            await fetchData()
        }
        
    }
    
    func fetchData() {
        Task {
#if targetEnvironment(simulator)
            await testSwimmingData()
#else
            await fetchSwimmingData()
#endif
        }
    }
    
    private func fetchSwimmingData() async {
        let swimmingData = await hkManager?.loadSwimmingDataCollection()
        if let swimmingData = swimmingData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.swimRecords = swimmingData
                self.sortHandler()
            }
        } else {
            return
        }
    }
    
    private func sortHandler() {
        switch self.sort {
        case .date:
            self.swimRecords.sort(by: { $0.startDate > $1.startDate })
        case .distance:
            self.swimRecords.sort(by: { $0.distance ?? 0 > $1.distance ?? 0 })
        case .duration:
            self.swimRecords.sort(by: { $0.duration > $1.duration })
        case .kcal:
            self.swimRecords.sort(by: { $0.activeKcal ?? 0 > $1.activeKcal ?? 0 })
        }
    }
    
}

#if targetEnvironment(simulator)
// Test Stub
extension SwimmingHistoryViewModel {
    private func testSwimmingData() async {
        DispatchQueue.main.async {
            self.swimRecords = TestObjects.swimmingData
            self.sortHandler()
        }
    }
}

#endif
