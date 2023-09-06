//
//  ChallangeRing.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI


struct ChallangeRing: Identifiable {
    
    let id = UUID()
    let type: WorkoutRecordType
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
            return "\(maxCount.toString())"
        case .lap:
            return "\(maxCount.toString())"
        case .countPerWeek:
            return "\(maxCount.toString())"
        default:
            return ""
        }
    }
    
    func progressPercentString() -> String {
        return "\((progress() * 100).toString())%"
    }

    func progress() -> Double {
        if count / maxCount == 0 {
            return 0.001
        } else {
            return count / maxCount
        }
    }
    
    func progressLabel() -> String {
        return count.toString()
    }
    
    func getCircleColor() -> Color {
        switch progress() {
        case 0...0.29:
            return AppColor.caloriesRed
        case 0.30...0.69:
            return Color(hex: "1ab8cd")
        case 0.70...1.0:
            return AppColor.secondaryBlue
        default:
            return Color.green
        }
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
            return UIColor.green
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

#if DEBUG
struct ChallangeRing_Previews: PreviewProvider {
    
    static var previews: some View {
        ChallangeRingView(rings: .constant(TestObjects.rings))
    }
}
#endif
