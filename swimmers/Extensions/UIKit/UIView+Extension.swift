//
//  UIView+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/4/23.
//

import UIKit

extension UIViewController {
    
    func updateView() {
        self.view.layoutIfNeeded()
    }
    
}

extension UIView {
    
    var id: String? {
        get {
            return self.accessibilityIdentifier
        }
        set {
            self.accessibilityIdentifier = newValue
        }
    }
    
    func view(withId id: String) -> UIView? {
        if self.id == id {
            return self
        }
        for view in self.subviews {
            if let view = view.view(withId: id) {
                return view
            }
        }
        return nil
    }
    
    static func spacer() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.init(249), for: .horizontal)
        view.setContentHuggingPriority(.init(249), for: .vertical)
        return view
    }
    
}

// UIView 상속하는 모든 뷰에서 사용
extension UIView {
    
    public func randomBackgroundColor<T: UIView>() -> T {
        self.backgroundColor = UIColor.randomColor()
        return self as! T
    }
    
    public func cornerRadius<T: UIView>(_ amount: CGFloat) -> T {
        self.layer.cornerRadius = amount
        return self as! T
    }
    
    public func backgroundColor<T: UIView>(_ color: UIColor) -> T {
        self.backgroundColor = color
        return self as! T
    }
    
    public func subview<T: UIView>(_ view: UIView) -> T {
        self.addSubview(view)
        return self as! T
    }
    
    public func disableUserInteraction<T: UIView>(_ disable: Bool) -> T {
        self.isUserInteractionEnabled = !disable
        return self as! T
    }

}
