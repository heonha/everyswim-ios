//
//  Font+Ext.swift
//  everyswim
//
//  Created by HeonJin Ha on 3/16/24.
//

import SwiftUI

extension Font {
    
    static func custom(_ name: AppFont, size: CGFloat) -> Font {
        return Font.custom(name.rawValue, size: size)
    }
    
}
