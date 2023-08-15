//
//  Int+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import Foundation

extension Int {
    
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}
