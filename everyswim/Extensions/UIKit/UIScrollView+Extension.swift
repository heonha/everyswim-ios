//
//  UIScrollView+Extension.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/21/23.
//

import UIKit

extension UIScrollView {
    
    func showsVerticalScrollIndicator<T: UIScrollView>(_ isTrue: Bool) -> T {
        self.showsVerticalScrollIndicator = isTrue
        return self as! T
    }
    
    func showsHorizontalScrollIndicator<T: UIScrollView>(_ isTrue: Bool) -> T {
        self.showsHorizontalScrollIndicator = isTrue
        return self as! T
    }
    
    func isPagingEnabled<T: UIScrollView>(_ isTrue: Bool) -> T {
        self.isPagingEnabled = isTrue
        return self as! T
    }

}
