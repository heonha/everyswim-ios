//
//  ActivityDataRange.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/30/23.
//

import Foundation

enum ActivityDataRange: Int, CaseIterable {
    case weekly
    case monthly
    case yearly
    case total
    
    var segmentTitle: String {
        switch self {
        case .weekly:
            return "주간"
        case .monthly:
            return "월간"
        case .yearly:
            return "연간"
        case .total:
            return "전체"
        }
    }
    
    var segmentSubtitle: String {
        switch self {
        case .weekly:
            return "이번 주"
        case .monthly:
            return "이번 달"
        case .yearly:
            return "올해"
        case .total:
            return "전체"
        }
    }
}
