//
//  DateValue.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/08/08.
//

import Foundation

struct DateValue: Identifiable {
    let id = UUID().uuidString
    let day: Int
    let date: Date
}
