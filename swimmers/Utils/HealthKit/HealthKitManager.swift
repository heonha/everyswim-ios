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
    var isAuth = false
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            healthStore = nil
        }
    }
    
    deinit {
        print("DEUBG DEINIT: HealthKitManager")
    }
    
}

extension HealthKitManager {
    
    //    func isAuthSuccess() {
    //        healthStore?.handleAuthorizationForExtension(completion: )
    //    }
    
    private func excuteQuery(healthStore: HKHealthStore?, query: HKStatCollectionQuery?) {
        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }
    
    private func healthDataType() -> Set<HKObjectType> {
        var set: Set<HKObjectType> = [
            // 활동
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.activeEnergyBurned)!, // 활동 에너지
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.swimmingStrokeCount)!, // 스트로크
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.distanceSwimming)!, // 수영 거리
            
            // 기타
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.basalEnergyBurned)!, // 휴식 에너지
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.vo2Max)! // 산소 소비량
        ]
        
        if #available(iOS 16.0, *) {
            let setWatchUltra: [HKObjectType] = [
                HKObjectType.quantityType(forIdentifier: HKDataTypeId.underwaterDepth)!, // 수중 깊이
                HKObjectType.quantityType(forIdentifier: HKDataTypeId.waterTemperature)! // 수온
            ]
            
            for object in setWatchUltra {
                set.insert(object)
            }
        }
        
        return set
    }
    
    func getHealthData(dataType: HKQueryDataType, queryRange: HKDateType, completion: @escaping (HKStatCollection?) -> Void) {
        calculateHealthData(dataType: dataType, queryRange: queryRange, completion: completion)
    }
    
    /// HKStatisticsCollection:
    /// 별도의 시간 간격으로 계산된 결과를 나타내는 통계 모음을 관리하는 개체입니다.
    private func calculateHealthData(dataType: HKQueryDataType, queryRange: HKDateType, completion: @escaping (HKStatCollection?) -> Void) {
        
        // 요청할 데이터 타입
        guard let healthDataType = dataType.dataType() else { return }
        
        // 7일 전이 시작 일자.
        let startDate = Calendar.current.date(byAdding: .day, value: queryRange.value(), to: Date())
        
        // 하루가 실제기록 시작되는 시간 (Anchor Date)
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        /// HKQuery 클래스는 HealthKit 저장소에서 데이터를 검색하는 모든 쿼리 객체의 기초입니다.
        /// HKQuery 클래스는 추상 클래스입니다. 직접 인스턴스화해서는 안됩니다.
        /// 대신 항상 구체적인 하위 클래스 중 하나로 작업합니다.
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        // 쿼리 수행
        query = HKStatCollectionQuery(quantityType: healthDataType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum,
                                      anchorDate: anchorDate,
                                      intervalComponents: daily)
        
        guard let query = query else { return }
        
        query.initialResultsHandler = { _, staticsCollection, _ in
            completion(staticsCollection)
        }
        
        excuteQuery(healthStore: healthStore, query: query)
        
    }
    
    func requestAuthorization(completion: @escaping (Bool?) -> Void) {
        print("DEBUG: 권한을 요청합니다.")
        /// HKObjectType: HealthKit 저장소에 대한 특정 유형의 데이터를 식별하는 서브클래스가 있는 추상 슈퍼클래스.
        let queryDataSet = self.healthDataType()
        guard let healthStore = healthStore else {
            print("DEBUG: Error \(HealthKitError.hkObjectTypeError)")
            return
        }
        
        // 권한 요청
        healthStore
            .requestAuthorization(toShare: [], read: queryDataSet) { success, error in
                if let error = error {
                    print("DEBUG: 에러가 발생했습니다. \(error)")
                    completion(nil)
                } else {
                    print("DEBUG HK Success :\(success)")
                    completion(success)
                }
            }
    }
    
    func checkAuthorizationStatus(_ type: HKQueryDataType?, completion: @escaping (Bool?) -> Void) {
        guard let healthDataType = type?.dataType() else {
            print("Invalid HealthKit data type.")
            return
        }
        
        let authorizationStatus = healthStore?.authorizationStatus(for: healthDataType)
        
        switch authorizationStatus {
        case .sharingAuthorized:
            print("HealthKit authorization is currently granted.")
            completion(true)
        case .notDetermined:
            print("HealthKit authorization is currently notDetermined.")
            completion(false)
        case .sharingDenied:
            print("HealthKit authorization is currently sharingDenied.")
            completion(false)
        case .none:
            print("HealthKit authorization is None.")
            completion(false)
        }
    }
}



// MARK: - 수영기록 가져오기
extension HealthKitManager {
    
    func requestPermission() async -> Bool {
        let write: Set<HKSampleType> = [.workoutType()]
        let read: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKSeriesType.workoutType()
        ]
        
        let res: ()? = try? await healthStore?.requestAuthorization(toShare: write, read: read)
        guard res != nil else {
            return false
        }
        
        return true
    }
    
    func readWorkouts() async -> [HKWorkout]? {
        
        print("Swimming Data가져오기 준비")
        // predicate
        let swimming = HKQuery.predicateForWorkouts(with: .swimming)
        
        // sortDescriptors
        let sortDescriptors: [NSSortDescriptor]? = [.init(keyPath: \HKSample.startDate, ascending: false)]
        
        print("Swimming 가져오기 준비 완료")
        let samples = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            print("Swimming 가져오기를 시작합니다.")

            let query = HKSampleQuery(sampleType: .workoutType(),
                                      predicate: swimming,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: sortDescriptors) { _, samples, error in
                if let error = error {
                    print("Swimming 가져오기 Error: \(error.localizedDescription).")
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }
                
                continuation.resume(returning: samples)
            }
            
            print("Swimming 가져오기: 쿼리를 시작합니다. \(query)")
            healthStore?.execute(query)
        }
        
        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }
        
        return workouts
    }
    
    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        let locations = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var allLocations: [CLLocation] = []
            
            // Create the route query.
            let query = HKWorkoutRouteQuery(route: givenRoute) { _, locationsOrNil, done, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let currentLocationBatch = locationsOrNil else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }
                
                allLocations.append(contentsOf: currentLocationBatch)
                
                if done {
                    continuation.resume(returning: allLocations)
                }
            }
            
            healthStore?.execute(query)
        }
        
        if let locations = locations {
            return locations
        } else {
            print("위치를 확인할 수 없음")
            return []
        }
        
    }
    
}
