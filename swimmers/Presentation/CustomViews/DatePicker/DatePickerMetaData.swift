//
//  DatePickerMetaData.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import Foundation

struct DatePickerMetaData: Identifiable {
    let id = UUID().uuidString
    let task: [SwimMainData]
    let taskDate: Date
}
