//
//  AppColor.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

enum AppUIColor {
    
    static let primary = UIColor(hex: "3284FE")
    static let primaryBlue = UIColor(hex: "0053CE")
    static let secondaryBlue = UIColor(hex: "2752EE")
    // static let primaryBackgorund = UIColor(hex: "FAFAFA")
    static let primaryBackgorund = UIColor.systemBackground
    static let secondaryBackground = UIColor.secondarySystemBackground
    static let skyBackground = UIColor(hex: "2B303C")

    static let caloriesRed = UIColor(hex: "D63B3B", alpha: 0.85)
    static let cellBackground = UIColor(hex: "F4F5F5")
    static let buttonDisableColor = UIColor(hex: "9FA6BF")
    static let grayTint = UIColor(hex: "3C3C43", alpha: 0.6)
    
    static let whiteUltraThinMaterialColor = UIColor.tertiarySystemFill
    static let whithThickMaterialColor = UIColor.secondarySystemFill
    
    // CircleColor
    static let circleGreen = UIColor(hex: "41D1B9", alpha: 1.0)
    static let circleBlue = UIColor(hex: "1ab8cd")
    
    // MARK: Base Label
    static let label = UIColor.label
    static let secondaryLabel = UIColor.secondaryLabel
    static let tertiaryLabel = UIColor.tertiaryLabel
    
}

enum AppColor {
    
    static let labelTint = Color.init(uiColor: .init(hex: "4489F0"))
    static let grayTint = Color.init(uiColor: .init(hex: "3C3C43", alpha: 0.6))
    static let darkGrayTint = Color.init(uiColor: .init(hex: "2B303C"))

    struct Gradient {
        static let first: [Color] = [.init(uiColor: .init(hex: "0080EC", alpha: 0.9)),
                                     .init(uiColor: .init(hex: "2083B9", alpha: 0.9)) ]
        
        static let second: [Color] = [.init(uiColor: .init(hex: "2B303C", alpha: 0.9)),
                                      .init(uiColor: .init(hex: "474C5A", alpha: 0.9))]
        
        static let calendarDayTint: [Color] = [.init(uiColor: .init(hex: "1288EC", alpha: 0.9)),
                                     .init(uiColor: .init(hex: "68B7FF", alpha: 0.9)) ]

    }
    
}
