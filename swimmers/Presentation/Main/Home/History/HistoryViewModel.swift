//
//  HistoryViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import Combine
import HealthKit

final class HistoryViewModel: ObservableObject {
    
    typealias Defaults = DefaultsName
    
    private var hkManager: HealthKitManager?
    
    @Published var swimRecords: [SwimMainData]
    @Published var animationRefreshPublisher = false
    @AppStorage(Defaults.recordViewSort) var sort: RecordSortType = .date
    @AppStorage(Defaults.recordViewAscending) var ascending = true
    
    init(swimRecords: [SwimMainData]? = nil,
         healthKitManager: HealthKitManager = HealthKitManager()) {
        self.swimRecords = swimRecords ?? []
        self.hkManager = healthKitManager
        
        self.fetchData()
    }
    
    func fetchData() {
#if targetEnvironment(simulator)
        Task { await testSwimmingData() }
#else
        Task { await fetchSwimmingData() }
#endif
    }
    
}

extension HistoryViewModel {
    
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
            if ascending {
                self.swimRecords.sort(by: { $0.startDate > $1.startDate })
            } else {
                self.swimRecords.sort(by: { $0.startDate < $1.startDate })
            }
        case .distance:
            if ascending {
                self.swimRecords.sort(by: { $0.detail?.distance ?? 0 > $1.detail?.distance ?? 0 })
            } else {
                self.swimRecords.sort(by: { $0.detail?.distance ?? 0 < $1.detail?.distance ?? 0 })
            }
        case .duration:
            if ascending {
                self.swimRecords.sort(by: { $0.duration > $1.duration })
            } else {
                self.swimRecords.sort(by: { $0.duration < $1.duration })
            }
        case .kcal:
            if ascending {
                self.swimRecords.sort(by: { $0.totalKcal > $1.totalKcal })
            } else {
                self.swimRecords.sort(by: { $0.totalKcal < $1.totalKcal })
            }
        }
        
        animateView()
    }
    
    private func animateView() {
        animationRefreshPublisher.toggle()
    }
    
}

#if targetEnvironment(simulator)
// Test Stub
extension HistoryViewModel {
    private func testSwimmingData() async {
        DispatchQueue.main.async {
            self.swimRecords = TestObjects.swimmingData
            self.sortHandler()
        }
    }
}

#endif
