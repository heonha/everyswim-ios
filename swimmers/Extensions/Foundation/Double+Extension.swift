//
//  Double+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import Foundation


extension Double {
    
    func toInt() -> Int {
        return Int(self)
    }
    
    /// 소수점을 제외하고 문자열로 변환합니다.
    func toString() -> String {
        let intVal = self.toInt()
        return "\(intVal.formattedString())"
    }
    
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}
