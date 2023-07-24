//
//  DateToStringType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/23.
//

import Foundation

enum DateToStringType {
    /// YYYY-M-d
    case date
    /// "yyyy년 M월 d일"
    case dateKr
    /// "yyyy년 M월 d일 H:mm"
    case fullDateKr
    /// "H:mm:ss"
    case time
    /// "H:mm"
    case timeWithoutSeconds
    
    var format: String {
        switch self {
        case .date:
            return "yyyy-M-d"
        case .dateKr:
            return "yyyy년 M월 dd일"
        case .fullDateKr:
            return "yyyy년 M월 d일 H:mm"
        case .time:
            return "H:mm:ss"
        case .timeWithoutSeconds:
            return "H:mm"
        }
    }
}
