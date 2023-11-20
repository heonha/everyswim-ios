//
//  BaseViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/19/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    func textfieldHideKeyboardGesture(textfield: UITextField) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldHideKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .systemBackground
    }
    
    @objc 
    func textFieldHideKeyboard() {
        self.view.endEditing(true)
    }
    
}
