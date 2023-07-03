//
//  Date+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

       return dateFormatter.string(from: self)
    }
    
    func toStringOnlyTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: self)
    }
    
}
