//
//  HomeViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import Combine
import HealthKit

final class HomeRecordsViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    var cancellables = Set<AnyCancellable>()
    
    private var kcals: [HKNormalStatus] = []
    private var stroke: [HKNormalStatus] = []
    
    let emptyRing = [
        ChallangeRing(type: .distance, count: 0, maxCount: 1),
        ChallangeRing(type: .lap, count: 0, maxCount: 1),
        ChallangeRing(type: .countPerWeek, count: 0, maxCount: 1)
    ]
    
    @Published var swimRecords: [SwimMainData]
    @Published var rings: [ChallangeRing] = []
    
    @Published var kcalPerWeek: Double = 0.0
    @Published var strokePerMonth: Double = 0.0
    @Published var lastWorkout: SwimMainData?
    
    init(swimRecords: [SwimMainData]? = nil, healthKitManager: HealthKitManager?) {
        self.rings = emptyRing
        self.swimRecords = swimRecords ?? []
        self.hkManager = healthKitManager ?? HealthKitManager()
        Task {
            await loadHealthCollection()
            await fetchSwimmingData()
            getLastWorkout()
        }
        #if DEBUG
        self.rings = fetchRingData()
        #endif
    }
    
    func getLastWorkout() {
        $swimRecords
            .receive(on: DispatchQueue.main)
            .map(\.first)
            .sink { [weak self] data in
                self?.lastWorkout = data
            }.store(in: &cancellables)
    }

    private func fetchSwimmingData() async {
       await hkManager?.loadSwimmingDataCollection()
       subscribeSwimmingData()
    }
    
    private func subscribeSwimmingData() {
        SwimDataStore.shared.swimmingData
            .throttle(for: 120, scheduler: DispatchQueue.main, latest: true)
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
        
    func loadHealthCollection() async {
        self.kcals = []
        self.stroke = []
        
        print("DEBUG: 헬스 데이터 가져오기")
        guard let hkManager = hkManager else { return }
        
        print("DEBUG: 인증을 확인합니다")
        
        let isAuthed = await hkManager.requestAuthorization()
        
        if isAuthed {
            hkManager.getHealthData(dataType: .kcal, queryRange: .week) { result in
                if let statCollection = result {
                    print("업데이트 \(statCollection)")
                    self.updateUIFromStatistics(statCollection, type: .kcal, queryRange: .week)
                } else {
                    print("Collection 가져오기실패")
                }
            }
        } else {
            print("DEBUG: Health 일반 데이터 권한이 거부되었습니다.")
        }
    }
    
    func updateUIFromStatistics(_ statCollection: HKStatisticsCollection,
                                type: HKQueryDataType,
                                queryRange: HKDateType) {
        
        guard let startDate = Calendar.current.date(byAdding: .day,
                                                    value: queryRange.value(),
                                                    to: Date()) else { return }
        let endDate = Date()
        
        print("Debug: \(#function) StatCollection만들기 시작")
        /// 시작 날짜부터 종료 날짜까지의 모든 시간 간격에 대한 통계 개체를 열거합니다.
        statCollection.enumerateStatistics(from: startDate, to: endDate) { statCollection, _ in
            
            switch type {
            case .kcal:
                let count = statCollection.sumQuantity()?.doubleValue(for: .kilocalorie())
                guard let count = count else { return }
                let data = HKNormalStatus(count: count, date: statCollection.startDate)
                print("Debug: kcal가 완료되었습니다. \(data)")
                self.kcals.append(data)
                
                DispatchQueue.main.async {
                    self.kcalPerWeek = self.kcals.reduce(0) { partialResult, kcal in
                        partialResult + kcal.count
                    }
                }
                print("DEBUG: Kcal per Week\(self.kcalPerWeek)")
            default:
                print("DEBUG: \(#function) 알수없는 오류. default에 도달했습니다.")
                return
            }
        }
    }
    
#if DEBUG
    func fetchRingData() -> [ChallangeRing] {
        return [
            ChallangeRing(type: .distance, count: 1680, maxCount: 2000),
            ChallangeRing(type: .lap, count: 45, maxCount: 60),
            ChallangeRing(type: .countPerWeek, count: 2, maxCount: 3)
        ]
    }
#endif
    
}
