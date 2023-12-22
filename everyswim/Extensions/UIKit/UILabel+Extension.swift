//
//  UILabel+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit

extension UILabel {
    
    func font(_ font: UIFont) -> UILabel {
        self.font = font
        return self
    }
    
    func foregroundColor(_ color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    
    func textAlignemnt(_ alignment: NSTextAlignment) -> UILabel {
        self.textAlignment = alignment
        return self
    }
    
    func adjustsFontSizeToFitWidth(_ isTrue: Bool = true) -> UILabel {
        self.adjustsFontSizeToFitWidth = isTrue
        return self
    }
    
    func setSecondaryAttributeText(separate: String = " ", font: UIFont, color: UIColor) {
        let fitstString = separate.first!
        
        if let originalFont = self.font {
            
            let attrString = NSMutableAttributedString(
                string: self.text ?? self.attributedText?.string ?? "",
                attributes: [.font: originalFont])
            
            if let text = self.text {
                if !text.isEmpty {
                    if let spaceIndex = text.firstIndex(of: fitstString) {
                        let index = text.distance(from: text.startIndex, to: spaceIndex)
                        print("\(index) \(text.endIndex)")
                        print(separate.description.count)
                        attrString.addAttributes([.font: font, .foregroundColor: color], 
                                                 range: NSMakeRange(index, separate.description.count))
                    }
                }
            }
            
            self.attributedText = attrString
        }
        
    }

}
