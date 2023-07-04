//
//  HKQueryDataType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/04.
//

import HealthKit

enum HKQueryDataType {
    case kcal, stroke, distance, restKcal, userO2
    case depth, waterTemp
    
    func dataType() -> HKQuantityType? {
        switch self {
        case .kcal:
            return HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        case .stroke:
            return HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)
        case .distance:
            return HKObjectType.quantityType(forIdentifier: .distanceSwimming)
        case .restKcal:
            return HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)
        case .userO2:
            return HKObjectType.quantityType(forIdentifier: .vo2Max)
        case .depth:
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .underwaterDepth)
            } else {
                return nil
            }
        case .waterTemp:
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .waterTemperature)
            } else {
                return nil
            }
        }
    }
}
