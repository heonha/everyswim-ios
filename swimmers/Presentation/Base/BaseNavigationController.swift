//
//  BaseNavigationController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.tintColor = .label
        hideNavigationBar(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
