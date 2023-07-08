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
            return "/ \(Int(maxCount))m"
        case .lap:
            return "/ \(Int(maxCount))회"
        case .countPerWeek:
            return "/ \(Int(maxCount))회"
        }
    }
    
    func progressPercentString() -> String {
        return "\((progress() * 100).toIntString())%"
    }

    func progress() -> Double {
        if count / maxCount == 0 {
            return 0.001
        } else {
            return count / maxCount
        }
    }
    
    func progressLabel() -> String {
        return "\(Int(count))"
    }
    
    var keyColor: Color {
        switch type {
        case .distance:
            return ThemeColor.secondaryBlue
        case .lap:
            return ThemeColor.primary
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
