//
//  UIColor+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit

extension UIColor {

    convenience init(hex hexcode: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hexcode)
        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff

        self.init(red: Double(red) / 0xff, green: Double(green) / 0xff, blue: Double(blue) / 0xff, alpha: alpha)
    }
    
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
