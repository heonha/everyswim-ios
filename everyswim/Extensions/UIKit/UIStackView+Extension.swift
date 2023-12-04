//
//  UIStackView+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit

extension UIStackView {
    
    enum StackViewEdgeInsets {
        case horizontal(_ value: CGFloat)
        case vertical(_ value: CGFloat)
        case all(_ value: CGFloat)
        case top(_ value: CGFloat)
        case leading(_ value: CGFloat)
        case trailing(_ value: CGFloat)
        case bottom(_ value: CGFloat)
        case each(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)
    }
    
    func setEdgeInset<T: UIStackView>(_ insets: StackViewEdgeInsets) -> T {
        if !self.isLayoutMarginsRelativeArrangement {
            self.isLayoutMarginsRelativeArrangement = true
        }
        
        let currentMargin = self.directionalLayoutMargins

        switch insets {
        case .horizontal(let value):
            self.directionalLayoutMargins = .init(top: currentMargin.top, leading: value, bottom: currentMargin.bottom, trailing: value)
        case .vertical(let value):
            self.directionalLayoutMargins = .init(top: value, leading: currentMargin.leading, bottom: value, trailing: currentMargin.trailing)
        case .all(let value):
            self.directionalLayoutMargins = .init(top: value, leading: value, bottom: value, trailing: value)
        case .top(let value):
            self.directionalLayoutMargins = .init(top: value, leading: currentMargin.leading, bottom: currentMargin.bottom, trailing: currentMargin.trailing)
        case .leading(let value):
            self.directionalLayoutMargins = .init(top: currentMargin.top, leading: value, bottom: currentMargin.bottom, trailing: currentMargin.trailing)
        case .trailing(let value):
            self.directionalLayoutMargins = .init(top: currentMargin.top, leading: currentMargin.leading, bottom: value, trailing: currentMargin.trailing)
        case .bottom(let value):
            self.directionalLayoutMargins = .init(top: currentMargin.top, leading: currentMargin.leading, bottom: currentMargin.bottom, trailing: value)
        case .each(let top, let leading, let bottom, let trailing):
            self.directionalLayoutMargins = .init(top: top, leading: leading, bottom: bottom, trailing: trailing)
        }
        
        return self as! T
    }
    
    
    func spacing<T: UIStackView>(_ spacing: CGFloat) -> T {
        self.spacing = spacing
        return self as! T
    }
    
    func distribution<T: UIStackView>(_ distribution: UIStackView.Distribution) -> T {
        self.distribution = distribution
        return self as! T
    }
    
    func alignment<T: UIStackView>(_ alignment: UIStackView.Alignment) -> T {
        self.alignment = alignment
        return self as! T
    }
    
    func axis<T: UIStackView>(_ axis: NSLayoutConstraint.Axis) -> T {
        self.axis = axis
        return self as! T
    }
    
    func addSubviews<T: UIStackView>(_ views: [UIView]) -> T {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
        return self as! T
    }
    
    func addSubview<T: UIStackView>(_ view: UIView) -> T {
        self.addArrangedSubview(view)
        self.clipsToBounds = true
        return self as! T
    }
        
}
