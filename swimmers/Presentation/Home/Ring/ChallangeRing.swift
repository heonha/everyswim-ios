//
//  ChallangeRing.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

enum RingType: String {
    case distance = "수영 거리"
    case lap = "랩"
    case countPerWeek = "수영 횟수"
}

struct ChallangeRing: Identifiable {
    
    let id = UUID()
    let type: RingType
    let count: Double
    let maxCount: Double

    var unit: String {
        switch type {
        case .distance:
            return "/ \(maxCount.toString())m"
        case .lap:
            return "/ \(maxCount.toString())회"
        case .countPerWeek:
            return "/ \(maxCount.toString())회"
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
    
    var keyColor: Color {
        switch type {
        case .distance:
            return AppColor.secondaryBlue
        case .lap:
            return AppColor.primary
        case .countPerWeek:
            return Color(hex: "1ab8cd")
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
