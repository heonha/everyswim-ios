//
//  HealthKitManager.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import HealthKit
import SwiftUI

class HealthKitManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    init() {
        
    }
    
    func requestAuthorization() {
        
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { success, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            switch success {
            case true:
                print("DEBUG: 건강데이터 권한 인증 성공")
            case false:
                print("DEBUG: 건강데이터 권한 인증 실패")
            }
        }
    }
    
    func queryBurnKcalories() {
        let start = Date()
        let end = Date()
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { query, result, error in
            if let error = error {
                print("DEBUG: \(#function) -> \(error.localizedDescription)")
                return
            }
            
            if let result = result {
                print(result as? [HKCategorySample] ?? [])
            }
        }
        
        healthStore.execute(query)
        
    }
    
    
}
