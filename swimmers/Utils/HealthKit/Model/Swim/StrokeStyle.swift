//
//  StrokeStyle.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import Foundation

enum StrokeStyle: Int {
    
    case backstroke
    case breaststroke
    case butterfly
    case freestyle
    case mixed
    case kickboard
    case unknown
    
    func name() -> String {
        switch self {
        case .backstroke:
            return "배영"
        case .breaststroke:
            return "평영"
        case .butterfly:
            return "접영"
        case .freestyle:
            return "자유형"
        case .mixed:
            return "혼영"
        case .kickboard:
            return "보드영"
        case .unknown:
            return "알수없음영"
        }
    }
    
}
