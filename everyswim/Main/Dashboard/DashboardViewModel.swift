//
//  DashboardViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import Combine
import HealthKit

final class DashboardViewModel: BaseViewModel, IOProtocol {
    
    struct Input {
        let viewWillAppearPublisher: AnyPublisher<Void, Never>
        let lastWorkoutCellTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateCollectionViewPublisher: AnyPublisher<Void, Never>
        let updateProfileViewPublisher: AnyPublisher<MyInfoProfile, Never>
        let updateLastWorkoutPublisher: AnyPublisher<SwimMainData, Never>
        let updateChallangeCircleAnimationPublisher: AnyPublisher<Void, Never>
        let pushWorkoutDetailViewPublisher: AnyPublisher<SwimMainData, Never>
        let updateRings: AnyPublisher<Void, Never>
    }

    private var authManager = AuthManager.shared
    
    /// 섹션 종류
    var recommandSections = RecommandSection.allCases
    
    // MARK: Health Data
    private var hkManager: HealthKitManager?
    private var kcals: [HKNormalStatus] = []
    private var stroke: [HKNormalStatus] = []
    private var profileLastUpdateDate: String = ""
    
    // MARK: Swimming Model
    @Published private(set) var rings: [RingViewModel] = []
    @Published private var lastWorkout: SwimMainData?
    @Published private(set) var kcalPerWeek: Double = 0.0
    @Published private(set) var strokePerMonth: Double = 0.0

    private var myinfoProfile = PassthroughSubject<MyInfoProfile?, Never>()
    
    // MARK: Recommand Model (Networking)
    private let recommandDataService = RecommandDataService()
    
    /// 추천 수영 `영상` 데이터
    private(set) var recommandVideos = CurrentValueSubject<[VideoCollectionData], Never>(.init())
    private let recommandVideosSuccess = PassthroughSubject<Void, Never>()
    /// 추천 `커뮤니티` 데이터
    private(set) var recommandCommunities = CurrentValueSubject<[CommunityCollectionData], Never>(.init())
    private let recommandCommunitiesSuccess = PassthroughSubject<Void, Never>()

    private var fetchedSwimData: AnyPublisher<Date?, Never> {
        return SwimDataStore.shared.lastUpdatedDate.eraseToAnyPublisher()
    }
    
    // MARK: Ring Data
    private let emptyRing = [
        RingViewModel(type: .distance, count: 0, maxCount: 1),
        RingViewModel(type: .lap, count: 0, maxCount: 1),
        RingViewModel(type: .countPerWeek, count: 0, maxCount: 1)
    ]
    
    // MARK: - 유저 정보 가져오기.
    func getUserProfile() -> MyInfoProfile {
        return authManager.getMyInfoProfile()
    }
    
    // MARK: - Init
    init(swimRecords: [SwimMainData]? = nil, healthKitManager: HealthKitManager? = nil) {
        self.rings = emptyRing
        self.hkManager = healthKitManager ?? HealthKitManager.shared
        super.init()
        SwimDataStore.shared.refreshSwimData()
        
        getRecommandCommunity()
        getRecommandVideos()
    }
    
    func transform(input: Input) -> Output {
        
        let updateCollectionView = Publishers
            .CombineLatest3(recommandVideosSuccess.eraseToAnyPublisher(),
                           recommandCommunitiesSuccess.eraseToAnyPublisher(),
                            input.viewWillAppearPublisher)
            .map { _, _, _ in return () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        let updateProfileView = Publishers
            .CombineLatest(input.viewWillAppearPublisher, 
                           authManager.isSignIn)
            .filter { _, isSignIn in
                return isSignIn
            }
            .compactMap { _ in
                self.needsProfileUpdate()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        /// 마지막 운동 기록 변동 감시 및 업데이트
        let updateLastWorkout =  SwimDataStore.shared.lastWorkoutData.eraseToAnyPublisher()
            .compactMap { $0 }
            .map { workoutData in
                self.fetchRingData()
                return workoutData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        let updateRings = Publishers
            .CombineLatest(SwimDataStore.shared.lastUpdatedDate,
                           UserData.shared.goal.eraseToAnyPublisher())
            .map { _ in
                return ()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        let pushWorkoutDetailView = input
            .lastWorkoutCellTapped
            .compactMap { self.lastWorkout }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        let updateChallangeCircleAnimationPublisher = input
            .viewWillAppearPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return Output(updateCollectionViewPublisher: updateCollectionView,
                      updateProfileViewPublisher: updateProfileView,
                      updateLastWorkoutPublisher: updateLastWorkout,
                      updateChallangeCircleAnimationPublisher: updateChallangeCircleAnimationPublisher,
                      pushWorkoutDetailViewPublisher: pushWorkoutDetailView,
                      updateRings: updateRings
        )
    }
    
    // MARK: - UserProfile
    func needsProfileUpdate() -> MyInfoProfile? {
        guard let hasProfile = authManager.user.value else { return nil }
        self.profileLastUpdateDate = hasProfile.lastUpdated
        let profileModel = getUserProfile()
        return profileModel
    }
    
    // MARK: - Recommand Data Methods
    private func getRecommandVideos() {
        recommandDataService
            .fetchVideo { [weak self] result in
            switch result {
            case .success(let data):
                self?.recommandVideos.send(data)
                self?.recommandVideosSuccess.send(())
            case .failure(let error):
                self?.sendMessage(message: "\(error):\(error.localizedDescription)")
                return
            }
        }
    }
    
    private func getRecommandCommunity() {
        recommandDataService
            .fetchCommunity { [weak self] result in
                switch result {
                case .success(let data):
                    self?.recommandCommunities.send(data)
                    self?.recommandCommunitiesSuccess.send(())
                case .failure(let error):
                    self?.sendMessage(message: "\(error):\(error.localizedDescription)")
                    return
                }
        }
    }
    
    // MARK: - Workout Data Methods
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
        SwimDataStore.shared.swimmingDataPubliser
            .receive(on: DispatchQueue.main)
            .sink { records in
                let goal = UserData.shared.goal.value
                let distance = records.reduce(0) { $0 + $1.unwrappedDistance }
                let lap = records.reduce(0) { $0 + $1.laps.count }
                let count = records.count
                
                self.rings =  [
                    RingViewModel(type: .distance, count: distance, maxCount: goal.distancePerWeek.toDouble()),
                    RingViewModel(type: .lap, count: lap.toDouble(), maxCount: goal.lapTimePerWeek.toDouble()),
                    RingViewModel(type: .countPerWeek, count: count.toDouble(), maxCount: goal.countPerWeek.toDouble())
                ]
            }.store(in: &cancellables)
    }

}
