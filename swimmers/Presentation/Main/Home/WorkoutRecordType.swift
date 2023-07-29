//
//  WorkoutRecordType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/24.
//

import SwiftUI

enum WorkoutRecordType: String {
    case distance = "수영 거리"
    case lap = "랩"
    case countPerWeek = "수영 횟수"
    case paceAverage
    case totalTime
    case bpmAverage
    case activeKcal
    case restKcal

    var title: String {
        switch self {
        case .distance:
            return "수영 거리"
        case .lap:
            return "랩"
        case .countPerWeek:
            return "수영 횟수"
        case .paceAverage:
            return "평균 페이스"
        case .totalTime:
            return "총 운동 시간"
        case .bpmAverage:
            return "평균 심박수"
        case .activeKcal:
            return "활동 칼로리"
        case .restKcal:
            return "휴식 칼로리"
        }
    }
    
    var imageName: String {
        switch self {
        case .distance:
            return "figure.pool.swim"
        case .lap:
            return "flag.checkered"
        case .countPerWeek:
            return "chart.xyaxis.line"
        case .paceAverage:
            return "chart.xyaxis.line"
        case .totalTime:
            return "timer"
        case .bpmAverage:
            return "heart.fill"
        case .activeKcal:
            return "flame.fill"
        case .restKcal:
            return "flame.circle"
        }
    }
    
    var imageColor: Color {
        switch self {
        default:
            return Color.init(uiColor: .systemBlue)
        }
    }
    
    var unit: String {
        switch self {
        case .distance, .paceAverage:
            return "m"
        case .lap:
            return "lap"
        case .countPerWeek:
            return "회"
        case .totalTime:
            return ""
        case .bpmAverage:
            return "BPM"
        case .activeKcal, .restKcal:
            return "kcal"
        }
    }
    
}
