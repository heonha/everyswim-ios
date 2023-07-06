//
//  TimeInterval+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import Foundation

extension TimeInterval {
    
    func stringFromTimeInterval() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko")

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        formatter.calendar = calendar

        let formattedString = formatter.string(from: self)!
        print(formattedString)
        
        return formattedString
    }
    
}
