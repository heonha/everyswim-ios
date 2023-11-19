//
//  BaseViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/19/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    @objc private func textFieldHideKeyboard(view: UIView) {
        view.endEditing(true)
    }
    
    func textfieldHideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldHideKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .systemBackground
    }
    
}
