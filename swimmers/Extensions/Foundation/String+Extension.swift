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
     
}
