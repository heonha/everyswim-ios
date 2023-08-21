//
//  DatePickerEventData.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/12/23.
//

import Foundation

struct DatePickerEventData: Identifiable {
    
    let id = UUID().uuidString
    let event: [SwimMainData]
    let eventDate: Date
    
}
