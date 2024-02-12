//
//  HealthKitManager.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import HealthKit
import SwiftUI
import CoreLocation

final class HealthKitManager {
    
    private var healthStore: HKHealthStore?
    
    private var query: HKStatisticsCollectionQuery?
    
    private lazy var swimDataManager = SwimDataManager(store: healthStore)
    
    static let shared = HealthKitManager()
    
    private init() {
        checkHealthDataSupportDevice()
    }
    
    deinit {
        print("DEINIT: HealthKitManager")
    }
    
}

// MARK: - 수영 데이터 관리
extension HealthKitManager {

    /// Health Data 가져오기 (일반 / 수영 제외)
    func getHealthData(dataType: HKQueryDataType,
                       queryRange: HKDateType,
                       completion: @escaping (HKStatisticsCollection?) -> Void) {
        calculateNormalHealthData(dataType: dataType, queryRange: queryRange, completion: completion)
    }
    
    /// 수영 데이터 가져와서 데이터 스토어로 보내기
    func fetchSwimData() async {
        // 건강 인증상태 확인
        guard await self.checkAllWorkoutDataAuthorization() else { return }
        
        // 수영 데이터 가져오기
        guard let workouts = try? await swimDataManager.fetchSwimDataFromDevice() else { return }
        
        // 데이터 스토어에 수영 데이터 보내기
        sendToSwimDataStore(data: workouts)
    }
    
    /// HealthData Support 되는 기기인지 체크
    private func checkHealthDataSupportDevice() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
        } else {
            self.healthStore = nil
        }
    }
    
    /// 수영 데이터 스토어로 데이터 보내기.
    private func sendToSwimDataStore(data: [HKWorkout]) {
    #if !targetEnvironment(simulator)
        // 실물 기기
        let swimData = swimDataManager.transformHKWorkoutToSwimData(data)
        SwimDataStore.shared.sendSwimData(swimData)
    #else
        // 시뮬레이터
        var swimData = SwimMainData.examples
        swimData.sort { $0.startDate < $1.startDate }
        SwimDataStore.shared.sendSwimData(swimData)
    #endif
    }
    
}

// MARK: - 일반 건강 데이터 가져오기
extension HealthKitManager {
    
    /// 기본 데이터 쿼리 (kcal, stroke, kcal)
    private func calculateNormalHealthData(dataType: HKQueryDataType,
                                           queryRange: HKDateType,
                                           completion: @escaping (HKStatisticsCollection?) -> Void) {

        // 데이터 타입 확인
        guard let healthDataType = dataType.dataType() else {
            completion(nil)
            return
        }
        
        // 시작 날짜
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: queryRange.value(), to: Date())
        // 자정으로 시간 설정
        let anchorDate = Date.mondayAt12AM()
        
        // 1일로 날짜 설정.
        let daily = DateComponents(day: 1)
        
        // Start Date로 부터 종료일 (오늘)까지의 쿼리
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        // 특정 조건으로 쿼리 생성 (Predicate)
        query = HKStatisticsCollectionQuery(quantityType: healthDataType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum,
                                      anchorDate: anchorDate,
                                      intervalComponents: daily)
        
        guard let query = query else {
            completion(nil)
            return
        }
        
        // 쿼리 초기화
        query.initialResultsHandler = { _, staticsCollection, _ in
            completion(staticsCollection)
        }
        
        // 쿼리 실행
        healthStore?.execute(query)
    }
    
}

// MARK: - 건강 권한 관련
extension HealthKitManager {

    func checkAuthorizationStatus() -> HKAuthorizationStatus? {
        return healthStore?.authorizationStatus(for: .workoutType())
    }
    
    /// 운동 데이터 R/W 권한 확인
    func checkAllWorkoutDataAuthorization() async -> Bool {
        let write: Set<HKSampleType> = [.workoutType()]
        let read: Set = queryTargetDataTypes()
        
        let res: ()? = try? await healthStore?.requestAuthorization(toShare: write, read: read)
        guard res != nil else {
            return false
        }
        return true
    }
    
    func checkAuthorizationStatus(_ type: HKQueryDataType?) async -> Bool {
        guard let healthDataType = type?.dataType() else {
            print("Invalid HealthKit data type.")
            return false
        }
        
        let authorizationStatus = healthStore?.authorizationStatus(for: healthDataType)
        
        switch authorizationStatus {
        case .sharingAuthorized:
            print("HealthKit authorization is currently granted.")
            return true
        case .notDetermined:
            print("HealthKit authorization is currently notDetermined.")
        case .sharingDenied:
            print("HealthKit authorization is currently sharingDenied.")
        case .none:
            print("HealthKit authorization is None.")
        case .some(let somes):
            print("HealthKit authorization is \(somes).")
        }
        return false
    }
    
}

// MARK: Query Helper
extension HealthKitManager {
    
    func excuteQuery(healthStore: HKHealthStore?, query: HKStatisticsCollectionQuery?) {
        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }
    
    private func queryTargetDataTypes() -> Set<HKObjectType> {
        let set: Set = [
            // 운동 타입
            .workoutType(),
            
            // 일반
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKSeriesType.workoutType(),
            
            // 수영 관련
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, // 활동 에너지
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.swimmingStrokeCount)!, // 스트로크
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)! // 수영 거리
        ]
        
        return set
    }
    
}
