//
//  DetailCellLabelType.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/30/23.
//

import Foundation

enum DetailCellLabelType {
    case averagePace
    case averagePaceWithoutUnit
    case duration
    case activeKcal
    case restKcal
    case averageBPM
    case poolLength
    case swim

    func getTypeLabel() -> String {
        switch self {
        case .averagePace, .averagePaceWithoutUnit:
            return "평균 페이스"
        case .duration:
            return "운동시간"
        case .activeKcal:
            return "활동 칼로리"
        case .restKcal:
            return "휴식 칼로리"
        case .averageBPM:
            return "평균 심박수"
        case .poolLength:
            return "레인 길이"
        case .swim:
            return "수영"
        }
    }
    
    func getUnit() -> String {
        switch self {
        case .averagePace:
            return "/100m"
        case .averagePaceWithoutUnit:
            return ""
        case .duration, .swim:
            return ""
        case .activeKcal, .restKcal:
            return "kcal"
        case .averageBPM:
            return "BPM"
        case .poolLength:
            return "m"
        }
    }
    
}
