//
//  UIImageView+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit

extension UIImageView {
    
    func contentMode(_ mode: UIImageView.ContentMode) -> UIImageView {
        self.contentMode = mode
        return self
    }
    
    func setImage(_ image: UIImage?) -> UIImageView {
        self.image = image ?? UIImage()
        return self
    }
    
    func setSymbolImage(systemName: String, color: UIColor = .black) -> UIImageView {
        let image = UIImage(systemName: systemName)?.withTintColor(color, renderingMode: .alwaysOriginal)
        self.image = image
        return self
    }

}
