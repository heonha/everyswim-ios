//
//  DateValue.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/08/08.
//

import SwiftUI

struct DateValue: Identifiable {
    
    let id = UUID().uuidString
    let day: Int
    let date: Date
    var weekday: Weekdays
    
}
