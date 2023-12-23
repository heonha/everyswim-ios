//
//  UIViewController+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit

extension UIViewController {

    // MARK: - Naviagtion VC
    func push(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

    func hideNavigationBar(_ isHide: Bool) {
        self.navigationController?.isNavigationBarHidden = isHide
    }
    
    func setNaviagationTitle(title: String) {
        self.navigationItem.title = title
    }
    
}
