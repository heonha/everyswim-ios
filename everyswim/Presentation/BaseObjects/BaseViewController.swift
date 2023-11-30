//
//  BaseViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/19/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
