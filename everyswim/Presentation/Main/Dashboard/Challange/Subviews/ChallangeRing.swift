//
//  ChallangeRing.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI


struct ChallangeRing: Identifiable {
    
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
        switch progress() {
        case 0...0.29:
            return AppUIColor.caloriesRed
        case 0.30...0.69:
            return UIColor(hex: "1ab8cd")
        case 0.70...1.0:
            return AppUIColor.secondaryBlue
        default:
            return UIColor.systemGreen
        }
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
