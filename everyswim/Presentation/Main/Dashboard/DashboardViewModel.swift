//
//  DashboardViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import Combine
import HealthKit

final class DashboardViewModel: ObservableObject {
        
    private var cancellables = Set<AnyCancellable>()

    private var hkManager: HealthKitManager?
    private var kcals: [HKNormalStatus] = []
    private var stroke: [HKNormalStatus] = []
    
    private let emptyRing = [
        ChallangeRing(type: .distance, count: 0, maxCount: 1),
        ChallangeRing(type: .lap, count: 0, maxCount: 1),
        ChallangeRing(type: .countPerWeek, count: 0, maxCount: 1)
    ]
    
    
    // MARK: Swimming Model
    @Published private(set) var swimRecords: [SwimMainData]
    @Published private(set) var rings: [ChallangeRing] = []
    @Published private(set) var lastWorkout: SwimMainData?
    @Published private(set) var kcalPerWeek: Double = 0.0
    @Published private(set) var strokePerMonth: Double = 0.0

    // MARK: Recommand Model
    /// 추천 수영 영상 데이터
    @Published private(set) var recommandVideos = [MediaCollectionData]()
    
    /// 추천 커뮤니티 데이터
    @Published private(set) var recommandCommunities = [CommunityCollectionData]()
    
    init(swimRecords: [SwimMainData]? = nil, healthKitManager: HealthKitManager? = nil) {
        self.rings = emptyRing
        self.swimRecords = swimRecords ?? []
        self.hkManager = healthKitManager ?? HealthKitManager()
        Task {
            await loadHealthCollection()
            await fetchSwimmingData()
            getLastWorkout()
        }

        self.fetchRingData()
    }
    
    func getLastWorkout() {
        $swimRecords
            .receive(on: DispatchQueue.main)
            .map(\.first)
            .sink { [weak self] data in
                print("lastWorkout를 셋업합니다.")
                self?.lastWorkout = data
            }.store(in: &cancellables)
    }

    private func fetchSwimmingData() async {
       await hkManager?.queryAllSwimmingData()
       subscribeSwimmingData()
    }
    
    private func subscribeSwimmingData() {
        SwimDataStore.shared
            .swimmingDataPubliser
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

    func fetchRingData() {
        self.$swimRecords
            .sink { records in
                let distance = records.reduce(0) { $0 + $1.unwrappedDistance }
                let lap = records.reduce(0) { $0 + $1.laps.count }
                let count = records.count
                
                self.rings =  [
                    ChallangeRing(type: .distance, count: distance, maxCount: 2000),
                    ChallangeRing(type: .lap, count: Double(lap), maxCount: 80),
                    ChallangeRing(type: .countPerWeek, count: Double(count), maxCount: 10)
                ]
            }.store(in: &cancellables)
    }
    
// #if DEBUG
//     func testFetchRingData() -> [ChallangeRing] {
//         return [
//             ChallangeRing(type: .distance, count: 1680, maxCount: 2000),
//             ChallangeRing(type: .lap, count: 45, maxCount: 80),
//             ChallangeRing(type: .countPerWeek, count: 2, maxCount: 10)
//         ]
//     }
// #endif
    
}
