//
//  UIImageView+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

extension UIImageView {
    
    func contentMode(_ mode: UIImageView.ContentMode) -> UIImageView {
        self.contentMode = mode
        return self
    }
    
    func setImage(_ image: UIImage?) -> UIImageView {
        self.image = image ?? UIImage()
        return self
    }
    
    func setSymbolImage(systemName: String, color: UIColor = .label) -> UIImageView {
        let image = UIImage(systemName: systemName)?.withTintColor(color, renderingMode: .alwaysOriginal)
        self.image = image
        return self
    }
    
    func updateSymbolImage(systemName: String, color: UIColor = .label) {
        let image = UIImage(systemName: systemName)?.withTintColor(color, renderingMode: .alwaysOriginal)
        self.image = image
    }
    
    func setSize(width: CGFloat, height: CGFloat) -> UIImageView {
        self.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        return self
        
    }

}
