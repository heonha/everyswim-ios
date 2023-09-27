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
    /// "yyyy년 M월 d일 h시 m분"
    case fullDateKr
    
    ///"M월 d일"
    case monthDayKr
    
    /// "M월"
    case monthKr

    
    /// "h:m:s"
    case time
    /// "h:m"
    case timeWithoutSeconds
    
    case month
    
    case year
    
    case dayDotMonth
    
    case weekDay
    
    var format: String {
        switch self {
        case .date:
            return "yyyy-M-d"
        case .fullDateKr:
            return "yyyy년 M월 d일 EEEE a h시 m분"
        case .dateKr:
            return "yyyy년 M월 d일 (E)"
        case .monthDayKr:
            return "M월 d일"
        case .monthKr:
            return "M월"
            
        case .time:
            return "a h:mm:ss"
        case .timeWithoutSeconds:
            return "a h:mm"
        case .dayDotMonth:
            return "M.dd"
        case .weekDay:
            return "EEEE"
        case .month:
            return "M"
        case .year:
            return "yyyy"

        }
    }
}
