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
    
    static func spacer(_ size: CGSize = .zero) -> UIView {
        let view = UIView(frame: .init(origin: .zero, size: size))
        view.setContentHuggingPriority(.init(249), for: .horizontal)
        view.setContentHuggingPriority(.init(249), for: .vertical)
        return view
    }
    
}

// UIView 상속하는 모든 뷰에서 사용
extension UIView {
    
    public func tag<T: UIView>(_ tag: Int) -> T {
        self.tag = tag
        return self as! T
    }
    
    public func randomBackgroundColor<T: UIView>() -> T {
        self.backgroundColor = UIColor.randomColor()
        return self as! T
    }
    
    public func cornerRadius<T: UIView>(_ amount: CGFloat) -> T {
        self.layer.cornerRadius = amount
        self.clipsToBounds = true
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
    
    public func shadow<T: UIView>(color: UIColor = .black,
                                  alpha: Float = 0.25,
                                  x: CGFloat = 0,
                                  y: CGFloat = 0,
                                  blur: CGFloat = 1,
                                  spread: CGFloat = 0,
                                  radius: CGFloat = 0) -> T {
        self.layer.setFigmaShadow(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread, radius: radius)
        return self as! T
    }
    
    public func contentHuggingPriority<T: UIView>(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> T {
        self.setContentHuggingPriority(priority, for: axis)
        return self as! T
    }
    
    public func contentCompressionResistancePriority<T: UIView>(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> T {
        self.setContentCompressionResistancePriority(priority, for: axis)
        return self as! T
    }

    
}


extension UIView {
    
    func gesturePublisher(_ type: GestureType = .tap()) -> GesturePublisher {
        return GesturePublisher(view: self, type: type)
    }
    
    
    static func divider(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        let divider = UIView(frame: .zero)
        divider.backgroundColor = .secondarySystemFill
        
        divider.snp.makeConstraints { make in
            if width != nil {
                make.width.equalTo(width!).priority(.high)
            }
            if height != nil {
                make.height.equalTo(height!).priority(.high)
            }
        }
        
        return divider
    }

}
