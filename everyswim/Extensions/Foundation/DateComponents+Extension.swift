//
//  DateComponents+Extension.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/28/23.
//

import Foundation

extension DateComponents {
    
    func setGMT9() -> DateComponents {
        var components = self
        components.timeZone = .init(secondsFromGMT: 9)
        return components
    }
    
}
