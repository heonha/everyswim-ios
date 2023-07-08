//
//  HKQueryDataType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/04.
//

import HealthKit

enum HKQueryDataType {
    case kcal, restKcal, stroke, distance
    
    func dataType() -> HKQuantityType? {
        switch self {
        case .kcal:
            return HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        case .restKcal:
            return HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)
        case .stroke:
            return HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)
        case .distance:
            return HKObjectType.quantityType(forIdentifier: .distanceSwimming)
        }
    }
}
