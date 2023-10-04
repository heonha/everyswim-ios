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
    
    func spacing(_ spacing: CGFloat) -> UIStackView {
        self.spacing = spacing
        return self
    }
    
    func distribution(_ distribution: UIStackView.Distribution) -> UIStackView {
        self.distribution = distribution
        return self
    }
    
    func alignment(_ alignment: UIStackView.Alignment) -> UIStackView {
        self.alignment = alignment
        return self
    }
    
    func axis(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        self.axis = axis
        return self
    }
    
    func addSubviews(_ views: [UIView]) -> UIStackView {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
        return self
    }
    
    func addSubview(_ view: UIView) -> UIView {
        self.addArrangedSubview(view)
        self.clipsToBounds = true
        return self
    }
        
}
