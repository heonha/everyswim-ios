//
//  Font+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

extension Font {

    static func custom(_ name: ThemeFont, size: CGFloat) -> Font {
        return Font.custom(name.rawValue, size: size)
    }

}
