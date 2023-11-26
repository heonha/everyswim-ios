//
//  HKDateType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/04.
//

import Foundation

enum HKDateType {
    case day
    case week
    case month
    
    func value() -> Int {
        switch self {
        case .day:
            return -1
        case .week:
            return -7
        case .month:
            return -30
        }
    }
    
}
