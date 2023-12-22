//
//  RootNavigationViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit

class RootNavigationViewController: UINavigationController {
    
    init(rootViewController: UIViewController, tintColor: UIColor = .label) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.tintColor = tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
