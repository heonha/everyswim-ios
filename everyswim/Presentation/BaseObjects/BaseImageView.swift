//
//  BaseImageView.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/15/23.
//

import UIKit
import SnapKit

final class BaseImageView: UIView {
    
    let contentView: UIImageView
    let size: CGSize
    
    init(size: CGSize, create: () -> UIImageView) {
        self.contentView = create()
        self.size = size
        super.init(frame: .zero)
        self.setImageViewSize(size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageViewSize(_ size: CGSize) {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.height.equalTo(size.height)
            make.width.equalTo(size.width)
            make.center.equalTo(self)
        }        
    }

}
