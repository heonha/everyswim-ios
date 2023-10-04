//
//  LoadingIndicator.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit

final class LoadingIndicator: UIActivityIndicatorView {
    
    override init(style: UIActivityIndicatorView.Style = .large) {
        super.init(style: style)
        self.configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.color = AppUIColor.primary
        self.hidesWhenStopped = true
    }
    
    func show() {
        self.isHidden = false
        self.startAnimating()
    }
    
    func hide() {
        self.isHidden = true
    }
    
}

