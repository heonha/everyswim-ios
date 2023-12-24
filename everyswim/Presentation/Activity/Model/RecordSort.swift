//
//  RecordSort.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/20.
//

import Foundation

enum RecordSort: String {
    case date
    case distance
    case duration
    case kcal
    
    var title: String {
        switch self {
        case .date:
            return "날짜 순"
        case .distance:
            return "거리"
        case .duration:
            return "운동시간"
        case .kcal:
            return "칼로리"
        }
    }
}
