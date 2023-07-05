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
    
    func getHealthData(dataType: HKQueryDataType, queryRange: HKDateType) async -> HKStatCollection? {
        return await calculateHealthData(dataType: dataType, queryRange: queryRange)
    }
    
    func getHealthData(dataType: HKQueryDataType, queryRange: HKDateType, completion: @escaping (HKStatCollection?) -> Void) {
        calculateHealthData(dataType: dataType, queryRange: queryRange, completion: completion)
    }
    
    /// Async사용
    private func calculateHealthData(dataType: HKQueryDataType, queryRange: HKDateType) async -> HKStatCollection? {
        
        print("데이터 계산 시작")
        guard let healthDataType = dataType.dataType() else { return nil }
        
        let startDate = Calendar.current.date(byAdding: .day, value: queryRange.value(), to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        // 쿼리 수행
        print("데이터 쿼리 만들기 시작")
        query = HKStatCollectionQuery(quantityType: healthDataType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum,
                                      anchorDate: anchorDate,
                                      intervalComponents: daily)
        
        guard let query = query else { return nil }
        
        print("collection 확인합니다.")
        var collection: HKStatCollection?
        query.initialResultsHandler = { _, staticsCollection, _ in
            collection = staticsCollection
        }
        print("쿼리를 실행합니다.")
        healthStore?.execute(query)
        return collection
    }
    
    /// Completion
    private func calculateHealthData(dataType: HKQueryDataType,
                                     queryRange: HKDateType,
                                     completion: @escaping (HKStatCollection?) -> Void) {
        print("데이터 계산 시작")
        
        if let healthDataType = dataType.dataType() {
            
            let startDate = Calendar.current.date(byAdding: .day, value: queryRange.value(), to: Date())
            let anchorDate = Date.mondayAt12AM()
            let daily = DateComponents(day: 1)
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: Date(),
                                                        options: .strictStartDate)
            
            // 쿼리 수행
            print("데이터 쿼리 만들기 시작")
            query = HKStatCollectionQuery(quantityType: healthDataType,
                                          quantitySamplePredicate: predicate,
                                          options: .cumulativeSum,
                                          anchorDate: anchorDate,
                                          intervalComponents: daily)
            
            if let query = query {
                
                print("collection 확인합니다.")
                var collection: HKStatCollection?
                
                query.initialResultsHandler = { _, staticsCollection, _ in
                    completion(staticsCollection)
                }
                healthStore?.execute(query)
            } else {
                completion(nil)
                return
            }
        } else {
            completion(nil)
        }
    }
    
}

// 보조 메소드
extension HealthKitManager {
    
    func excuteQuery(healthStore: HKHealthStore?, query: HKStatCollectionQuery?) {
        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }
    
    private func healthDataType() -> Set<HKObjectType> {
        let set: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKSeriesType.workoutType(),
            // 활동
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.activeEnergyBurned)!, // 활동 에너지
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.swimmingStrokeCount)!, // 스트로크
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.distanceSwimming)!, // 수영 거리
            
            // 기타
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.basalEnergyBurned)!, // 휴식 에너지
            HKObjectType.quantityType(forIdentifier: HKDataTypeId.vo2Max)! // 산소 소비량
        ]
        
        return set
    }
    
}

// MARK: - 권한 관련 메소드
extension HealthKitManager {
    
    func requestAuthorization() async -> Bool {
        let write: Set<HKSampleType> = [.workoutType()]
        let read: Set = healthDataType()
        
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

// MARK: - 수영기록 가져오기
extension HealthKitManager {
    
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
                
                guard let samples = samples else { print("수영 데이터 샘플값이 nil입니다."); return }
                
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
            let query = HKWorkoutRouteQuery(route: givenRoute) { _, currentLocations, success, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let currentLocations = currentLocations else {
                    print("DEBUG: 위치값이 nil입니다.")
                    return
                }
                
                allLocations.append(contentsOf: currentLocations)
                
                if success {
                    continuation.resume(returning: allLocations)
                }
            }
            healthStore?.execute(query)
        }
        
        if let locations = locations {
            return locations
        } else {
            print("DEBUG: 수영 한 곳의 위치를 확인할 수 없음")
            return []
        }
    }
    
}
