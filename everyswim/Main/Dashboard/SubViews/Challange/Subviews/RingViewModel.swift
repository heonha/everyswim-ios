//
//  ChallangeRing.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct RingViewModel: Identifiable {
    
    let id = UUID()
    let type: ChallangeRecordType
    let count: Double
    let maxCount: Double
    
    var unit: String {
        switch type {
        case .distance:
            return "m"
        case .lap:
            return "Lap"
        case .countPerWeek:
            return "회"
        default:
            return ""
        }
    }

    var challengeValue: String {
        switch type {
        case .distance:
            return "\(maxCount.toRoundupString())"
        case .lap:
            return "\(maxCount.toRoundupString())"
        case .countPerWeek:
            return "\(maxCount.toRoundupString())"
        default:
            return ""
        }
    }
    
    func progressPercentString() -> String {
        return "\((progress() * 100).toRoundupString())%"
    }

    func progress() -> Double {
        if count / maxCount == 0 {
            return 0.001
        } else {
            return count / maxCount
        }
    }
    
    func progressLabel() -> String {
        return count.toRoundupString()
    }
    
    func getCircleUIColor() -> UIColor {
            return AppUIColor.primaryBlue
    }
    
    var keyIcon: String {
        switch type {
        case .distance:
            return "figure.pool.swim"
        case .lap:
            return "flag.checkered"
        case .countPerWeek:
            return "chart.xyaxis.line"
        default:
            return ""
        }
    }

}

extension RingViewModel: TestableObject {
    
    static let examples: [RingViewModel] = [
        RingViewModel(type: .distance, count: 2001, maxCount: 2000),
        RingViewModel(type: .lap, count: 45, maxCount: 60),
        RingViewModel(type: .countPerWeek, count: 2, maxCount: 3)
    ]
    
}
