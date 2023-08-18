//
//  DatePickerMetaData.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import Foundation

struct DatePickerMetaData: Identifiable {
    
    let id = UUID().uuidString
    let event: [SwimMainData]
    let taskDate: Date
    
}
