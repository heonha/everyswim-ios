//
//  UITableView+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit

extension UITableView {
    
    func hideSeparate() {
        self.separatorStyle = .none
    }
    
    func isScrollEnabled<T: UITableView>(_ isTrue: Bool) -> T {
        self.isScrollEnabled = isTrue
        return self as! T
    }
    
    func separatorColor<T: UITableView>(_ color: UIColor) -> T {
        self.separatorColor = color
        return self as! T
    }
    
}
