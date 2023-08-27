//
//  UIStackView+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit

extension UIStackView {
    
    func setEdgeInset(_ insets: NSDirectionalEdgeInsets) -> UIStackView {
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = .init(top: insets.top, leading: insets.leading, bottom: insets.bottom, trailing: insets.trailing)
        
        return self
    }
    
    func setSpacing(_ spacing: CGFloat) -> UIStackView {
        self.spacing = spacing
        return self
    }
    
}
