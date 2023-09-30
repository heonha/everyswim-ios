//
//  HistoryViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import SwiftUI
import Combine
import HealthKit

final class AllRecordListViewModel: ObservableObject {
    
    typealias Defaults = DefaultsName
    
    private var hkManager: HealthKitManager?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var swimRecords: [SwimMainData]
    @Published var animationRefreshPublisher = false
    @Published var isLoading: Bool = true
    @AppStorage(Defaults.recordViewSort) var sortType = RecordSortType.date
    @AppStorage(Defaults.recordViewAscending) var ascending = true
    
    init(swimRecords: [SwimMainData]? = nil,
         healthKitManager: HealthKitManager = HealthKitManager()) {
        self.swimRecords = swimRecords ?? []
        self.hkManager = healthKitManager
        self.subscribeSwimmingData()
        self.fetchData()
    }
    
}

extension AllRecordListViewModel {
    
    func fetchData() {
#if targetEnvironment(simulator)
        Task { 
            await testSwimmingData()
        }
#else
        Task {
            await fetchSwimmingData()
        }
#endif
    }
    
    private func fetchSwimmingData() async {
        await hkManager?.loadSwimmingDataCollection()
        sortHandler()
        self.isLoading = false
    }
    
    private func subscribeSwimmingData() {
        SwimDataStore.shared
            .swimmingDataPubliser
            .throttle(for: 10, scheduler: DispatchQueue.main, latest: true)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    return
                }
            } receiveValue: { [weak self] swimData in
                DispatchQueue.main.async {
                    self?.swimRecords = swimData
                }
            }
            .store(in: &cancellables)
    }
    
    func sortRecords(sortType: RecordSortType) {
        if self.sortType == sortType {
            self.ascending.toggle()
            sortHandler()
        } else {
            self.sortType = sortType
            sortHandler()
        }
        
    }
        
    func sortHandler() {
        switch self.sortType {
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
extension AllRecordListViewModel {
    private func testSwimmingData() async {
        subscribeSwimmingData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.sortHandler()
            self.isLoading = false
        }
    }
}

#endif
