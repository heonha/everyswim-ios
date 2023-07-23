//
//  DateToStringType.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/23.
//

import Foundation

enum DateToStringType {
    /// YYYY-MM-DD
    case date
    /// "yyyy년 MM월 dd일"
    case dateKr
    /// "HH:mm:ss"
    case time
    /// "HH:mm"
    case timeWithoutSeconds
    
    var format: String {
        switch self {
        case .date:
            return "yyyy-MM-dd"
        case .dateKr:
            return "yyyy년 MM월 dd일"
        case .time:
            return "HH:mm:ss"
        case .timeWithoutSeconds:
            return "HH:mm"
        }
    }
}
