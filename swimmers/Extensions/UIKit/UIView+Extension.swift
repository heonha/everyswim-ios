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
    
    func randomBackgroundColor() -> UIView {
        self.backgroundColor = UIColor.randomColor()
        return self
    }

}
