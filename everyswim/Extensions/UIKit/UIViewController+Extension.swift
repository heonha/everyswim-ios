//
//  UIViewController+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit

extension UIViewController {
    
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.view.backgroundColor = backgroundColor
    }
    
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
    
    func presentAlert(title: String?, message: String?, target: UIViewController, action: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        if let alertAction = action {
            alertAction.forEach { action in
                print("액션을 셋업합니다.")
                alert.addAction(action)
            }
        } else {
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
        }
        target.present(alert, animated: true)
    }
    
    func setNaviagationTitle(title: String) {
        self.navigationItem.title = title
    }
    
}
