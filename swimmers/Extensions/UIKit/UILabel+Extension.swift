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
    
}
