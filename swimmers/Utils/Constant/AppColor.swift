//
//  AppColor.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

enum AppColor {
    
    static let primary = Color(hex: "3284FE")
    static let primaryBlue = Color(hex: "08467D")
    static let secondaryBlue = Color(hex: "2752EE")
    static let primaryBackgorund = Color(hex: "FAFAFA")
    static let secondaryBackground = Color(hex: "F8F9FF")
    static let skyBackground = Color(hex: "EDF2FB")

    static let caloriesRed = Color(hex: "D63B3B").opacity(0.85)
    static let cellBackground = Color(hex: "F4F5F5")
    static let buttonDisableColor = Color(hex: "9FA6BF")
    static let grayTint = Color(hex: "3C3C43").opacity(0.6)
    
}

enum AppUIColor {
    
    static let primary = UIColor(hex: "3284FE")
    static let primaryBlue = UIColor(hex: "08467D")
    static let secondaryBlue = UIColor(hex: "2752EE")
    static let primaryBackgorund = UIColor(hex: "FAFAFA")
    static let secondaryBackground = UIColor(hex: "F8F9FF")
    static let skyBackground = UIColor(hex: "EDF2FB")

    static let caloriesRed = UIColor(hex: "D63B3B", alpha: 0.85)
    static let cellBackground = UIColor(hex: "F4F5F5")
    static let buttonDisableColor = UIColor(hex: "9FA6BF")
    static let grayTint = UIColor(hex: "3C3C43", alpha: 0.6)
    
    static let whiteUltraThinMaterialColor = UIColor(hex: "F6F6F7", alpha: 1)
    static let whithThickMaterialColor = UIColor(hex: "F1F3F5")
    
}
