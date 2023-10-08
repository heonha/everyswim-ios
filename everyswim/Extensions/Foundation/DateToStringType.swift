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
    
    /// "yyyy.MM"
    case yearMonth
    
    ///"M월 d일"
    case monthDayKr
    
    /// "M월"
    case monthKr

    /// "h:m:s"
    case time
    /// "h:m"
    case timeWithoutSeconds
    
    case day
    
    /// "M"
    case month
    case monthFull

    case year
    
    /// "M.dd"
    case dayDotMonth
    
    /// "YYYY. M. dd"
    case fullDotDate
    
    case weekDay
    
    case weekdayTime
    
    var format: String {
        switch self {
        case .date:
            return "yyyy-M-d"
        case .fullDateKr:
            return "yyyy년 M월 d일 EEEE a h시 m분"
        case .dateKr:
            return "yyyy년 M월 d일 (E)"
        case .yearMonth:
            return "yyyy.MM"
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
        case .fullDotDate:
            return "YYYY. M. dd"
        case .weekDay:
            return "EEEE"
        case .month:
            return "M"
        case .monthFull:
            return "MM"
        case .day:
            return "d"
        case .year:
            return "yyyy"
        case .weekdayTime:
            return "EEEE a"

        }
    }
}
