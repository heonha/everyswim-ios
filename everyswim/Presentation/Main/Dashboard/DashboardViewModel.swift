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
    private var authManager = AuthManager.shared
    
    // MARK: Health Data
    private var hkManager: HealthKitManager?
    private var kcals: [HKNormalStatus] = []
    private var stroke: [HKNormalStatus] = []
    private var needUpdateProfile = false
    private var profileLastUpdateDate: String = ""
    
    // MARK: Swimming Model
    @Published private(set) var swimRecords: [SwimMainData]
    @Published private(set) var rings: [ChallangeRing] = []
    @Published private(set) var lastWorkout: SwimMainData?
    @Published private(set) var kcalPerWeek: Double = 0.0
    @Published private(set) var strokePerMonth: Double = 0.0

    private(set) var myinfoProfile = CurrentValueSubject<MyInfoProfile?, Never>(nil)
    
    // MARK: Recommand Model (Networking)
    private let recommandDataService = RecommandDataService()
    
    /// 추천 수영 `영상` 데이터
    private(set) var recommandVideos = [VideoCollectionData]()
    @Published private(set) var recommandVideoSuccessed = false
    
    /// 추천 `커뮤니티` 데이터
    private(set) var recommandCommunities = [CommunityCollectionData]()
    @Published private(set) var recommandCommunitySuccessed = false

    // MARK: Ring Data
    private let emptyRing = [
        ChallangeRing(type: .distance, count: 0, maxCount: 1),
        ChallangeRing(type: .lap, count: 0, maxCount: 1),
        ChallangeRing(type: .countPerWeek, count: 0, maxCount: 1)
    ]
    
    // MARK: - 유저 정보 가져오기.
    func getUserProfile() -> MyInfoProfile {
        return authManager.getMyInfoProfile()
    }
    
    // MARK: - Init
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
        self.getRecommandVideos()
        self.getRecommandCommunity()
    }
    
    // MARK: - UserProfile
    func needsProfileUpdate() -> Bool {
        guard let profile = authManager.user.value else { return false }
        if profile.lastUpdated != self.profileLastUpdateDate {
            self.profileLastUpdateDate = profile.lastUpdated
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Recommand Data Methods
    func getRecommandVideos() {
        recommandDataService.fetchVideo { [weak self] videoData in
            self?.recommandVideos.removeAll()
            videoData.forEach { data in
                self?.recommandVideos.append(data)
            }
            self?.recommandVideoSuccessed = true
        }
    }
    
    func getRecommandCommunity() {
        recommandDataService.fetchCommunity { [weak self] videoData in
            self?.recommandCommunities.removeAll()
            videoData.forEach { data in
                self?.recommandCommunities.append(data)
            }
            self?.recommandCommunitySuccessed = true
        }
    }
    
    // MARK: - Workout Data Methods
    func getLastWorkout() {
        $swimRecords
            .receive(on: DispatchQueue.main)
            .map(\.first)
            .sink { [weak self] data in
                self?.lastWorkout = data
            }.store(in: &cancellables)
    }

    private func fetchSwimmingData() async {
       await hkManager?.queryAllSwimmingData()
       subscribeSwimmingData()
    }
    
    /// 수영 데이터 가져오기
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
    
    /// 일반 건강 데이터 가져오기(수영 외)
    func loadHealthCollection() async {
        self.kcals = []
        self.stroke = []
        
        guard let hkManager = hkManager else { return }
        
        let isAuthed = await hkManager.requestAuthorization()
        
        if isAuthed {
            hkManager.getHealthData(dataType: .kcal, queryRange: .week) { result in
                if let statCollection = result {
                    self.updateUIFromStatistics(statCollection, type: .kcal, queryRange: .week)
                } else {
                    print("Collection 가져오기실패")
                }
            }
        } else {
            print("DEBUG: Health 일반 데이터 권한이 거부되었습니다.")
        }
    }
    
    /// Statistics 가져오기
    func updateUIFromStatistics(_ statCollection: HKStatisticsCollection,
                                type: HKQueryDataType,
                                queryRange: HKDateType) {
        
        guard let startDate = Calendar.current.date(byAdding: .day,
                                                    value: queryRange.value(),
                                                    to: Date()) else { return }
        let endDate = Date()
        
        statCollection.enumerateStatistics(from: startDate, to: endDate) { statCollection, _ in
            
            switch type {
            case .kcal:
                let count = statCollection.sumQuantity()?.doubleValue(for: .kilocalorie())
                guard let count = count else { return }
                let data = HKNormalStatus(count: count, date: statCollection.startDate)
                self.kcals.append(data)
                
                DispatchQueue.main.async {
                    self.kcalPerWeek = self.kcals.reduce(0) { partialResult, kcal in
                        partialResult + kcal.count
                    }
                }
            default:
                print("DEBUG: \(#function) 알수없는 오류. default에 도달했습니다.")
                return
            }
        }
    }

    // MARK: - Ring Dada Methods
    /// Ring 데이터 가져오기
    func fetchRingData() {
        self.$swimRecords
            .sink { records in
                let goal = UserData.shared.goal
                let distance = records.reduce(0) { $0 + $1.unwrappedDistance }
                let lap = records.reduce(0) { $0 + $1.laps.count }
                let count = records.count
                
                self.rings =  [
                    ChallangeRing(type: .distance, count: distance, maxCount: goal.distancePerWeek.toDouble()),
                    ChallangeRing(type: .lap, count: lap.toDouble(), maxCount: goal.lapTimePerWeek.toDouble()),
                    ChallangeRing(type: .countPerWeek, count: count.toDouble(), maxCount: goal.countPerWeek.toDouble())
                ]
            }.store(in: &cancellables)
    }

}
