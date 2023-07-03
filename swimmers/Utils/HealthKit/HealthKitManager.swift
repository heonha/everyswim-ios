//
//  HealthKitManager.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import HealthKit
import SwiftUI

class HealthKitManager: ObservableObject {
    
    let healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery? = nil
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            healthStore = nil
        }
    }
    
    /// HKStatisticsCollection:
    /// 별도의 시간 간격으로 계산된 결과를 나타내는 통계 모음을 관리하는 개체입니다.
    func calculateKcal(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        // 요청할 데이터 타입
        let healthDataType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        
        
        // 7일 전이 시작 일자.
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        // 하루가 실제록 시작되는 시간 (Anchor Date)
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        /// HKQuery 클래스는 HealthKit 저장소에서 데이터를 검색하는 모든 쿼리 객체의 기초입니다.
        /// HKQuery 클래스는 추상 클래스입니다. 직접 인스턴스화해서는 안됩니다.
        /// 대신 항상 구체적인 하위 클래스 중 하나로 작업합니다.
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        // 쿼리 수행
        query = HKStatisticsCollectionQuery(quantityType: healthDataType,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        query!.initialResultsHandler = { query, staticsCollection, error in
            completion(staticsCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        

    }
    
    
    func requestAuthorization(completion: @escaping (Bool?) -> Void) {

        /// HKObjectType: HealthKit 저장소에 대한 특정 유형의 데이터를 식별하는 서브클래스가 있는 추상 슈퍼클래스.
        let kcalType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!

        // 권한 요청
        healthStore?.requestAuthorization(toShare: [], read: [kcalType]) { (success, error) in
            completion(success)
        }
    }
//
//    func queryBurnKcalories() {
//        let start = Date()
//        let end = Date()
//        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { query, result, error in
//            if let error = error {
//                print("DEBUG: \(#function) -> \(error.localizedDescription)")
//                return
//            }
//
//            if let result = result {
//                print(result as? [HKCategorySample] ?? [])
//            }
//        }
//
//        healthStore.execute(query)
//
//    }
//
    
}
