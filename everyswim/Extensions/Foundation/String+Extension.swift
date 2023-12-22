//
//  String+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         dateFormatter.locale = Locale(identifier: "ko_KR")
         dateFormatter.timeZone = TimeZone(abbreviation: "KST")

         return dateFormatter.date(from: self)
     }
    
    func toDateWithTime() -> Date? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm"
         dateFormatter.locale = Locale(identifier: "ko_KR")
         dateFormatter.timeZone = TimeZone(abbreviation: "KST")

         return dateFormatter.date(from: self)
     }
     
    func toInt() -> Int? {
        return Int(self)
    }
    
    // MARK: - Remove Bold Tag for Location Response
    
    func removeBoldTagsToGap() -> String {
        return self.replacingOccurrences(of: "<b>", with: " ", options: .regularExpression, range: nil)
    }
    
    func removeBoldEndTagsToGap() -> String {
        return self.replacingOccurrences(of: "</b>", with: " ", options: .regularExpression, range: nil)
    }

    func cleanLocationName() -> String {
        return self.removeBoldTagsToGap().removeBoldEndTagsToGap()
    }
    
    func toCoordinate() -> Double {
        guard let doubleData = Double(self) else { return 0 }
        return doubleData / 10_000_000
    }
    
}
