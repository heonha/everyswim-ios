//
//  WeekDays.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/16/23.
//

import SwiftUI

enum Weekdays: Int {
    
    static let values = ["일", "월", "화", "수", "목", "금", "토"]
    
    case sun
    case mon
    case tue
    case wed
    case thus
    case fri
    case sat
    case error
    
    
    var color: Color {
        switch self {
        case .sun: return Color.red
        case .sat: return Color.blue
        default: return Color.black
        }
    }

}
