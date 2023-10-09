//
//  HealthKitManager.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import HealthKit
import SwiftUI
import CoreLocation

class HealthKitManager {
    
    typealias HKStatCollectionQuery = HKStatisticsCollectionQuery
    typealias HKStatCollection = HKStatisticsCollection
    typealias HKDataTypeId = HKQuantityTypeIdentifier
    
    private let healthStore: HKHealthStore?
    private var query: HKStatCollectionQuery?
    
    private lazy var swimDataManager = SwimDataManager(store: healthStore)
    
    var isAuth = false
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            print("INIT: HealthKitManager")
            healthStore = HKHealthStore()
        } else {
            healthStore = nil
        }
    }
    
    deinit {
        print("DEUBG DEINIT: HealthKitManager")
    }
    
}

// MARK: - Swimming Data Getter
extension HealthKitManager {
    
    func getHealthData(dataType: HKQueryDataType, queryRange: HKDateType, completion: @escaping (HKStatCollection?) -> Void) {
        calculateNormalHealthData(dataType: dataType, queryRange: queryRange, completion: completion)
    }
    
    func queryAllSwimmingData() async {
        if await !self.requestAuthorization() { return }

        guard let workouts = await swimDataManager.readSwimmingWorkoutData() else { return }
        
        #if targetEnvironment(simulator)
        let swimData = TestObjects.swimmingData
        SwimDataStore.shared.sendSwimData(swimData)
        #else
        let swimData = swimDataManager.createSwimMainData(workouts)
        #endif
        SwimDataStore.shared.sendSwimData(swimData)
    }
    
}

// MARK: - Allstat Logics
extension HealthKitManager {
    
    /// 기본 데이터 쿼리 (kcal, stroke, kcal)
    private func calculateNormalHealthData(dataType: HKQueryDataType,
                                           queryRange: HKDateType,
                                           completion: @escaping (HKStatCollection?) -> Void) {

        guard let healthDataType = dataType.dataType() else { completion(nil); return }
        
        let startDate = Calendar.current.date(byAdding: .day, value: queryRange.value(), to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        // 쿼리 수행
        query = HKStatCollectionQuery(quantityType: healthDataType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum,
                                      anchorDate: anchorDate,
                                      intervalComponents: daily)
        
        guard let query = query else {
            completion(nil)
            return
        }
        
        query.initialResultsHandler = { _, staticsCollection, _ in
            completion(staticsCollection)
        }
        
        healthStore?.execute(query)
    }
    
}

// MARK: - 권한 관련
extension HealthKitManager {

    func checkAuthorizationStatus() -> HKAuthorizationStatus? {
        return healthStore?.authorizationStatus(for: .workoutType())
    }

    
    func requestAuthorization() async -> Bool {
        let write: Set<HKSampleType> = [.workoutType()]
        let read: Set = queryDataTypeForSwimming()
        
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
    
    func excuteQuery(healthStore: HKHealthStore?, query: HKStatCollectionQuery?) {
        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }
    
    private func queryDataTypeForSwimming() -> Set<HKObjectType> {
        let set: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKSeriesType.workoutType(),
            // 활동
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.activeEnergyBurned)!, // 활동 에너지
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.swimmingStrokeCount)!, // 스트로크
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.distanceSwimming)! // 수영 거리
        ]
        
        return set
    }
    
}
