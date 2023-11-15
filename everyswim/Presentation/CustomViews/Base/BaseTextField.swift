//
//  BaseTextField.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/15/23.
//

import UIKit

final class BaseTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    func configure() {
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.font = .custom(.sfProLight, size: 14)
        self.clearButtonMode = .unlessEditing
    }
    
    func placeholder(_ text: String) -> BaseTextField {
        self.placeholder = text
        return self
    }
    
    func font(_ font: UIFont) -> BaseTextField {
        self.font = font
        return self
    }
    
}
