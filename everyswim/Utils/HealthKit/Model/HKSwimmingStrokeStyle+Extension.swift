//
//  HKSwimmingStrokeStyle+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/23.
//

import Foundation
import HealthKit

extension HKSwimmingStrokeStyle {
    
    var name: String {
        switch self {
        case .unknown:
            return "알수 없는 영법"
        case .mixed:
            return "혼영"
        case .freestyle:
            return "자유형"
        case .backstroke:
            return "배영"
        case .breaststroke:
            return "평영"
        case .butterfly:
            return "접영"
        case .kickboard:
            return "보드영"
        @unknown default:
            return "알려지지 않은 영법"
        }
    }
    
}
