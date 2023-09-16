//
//  BaseScrollView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit
import SnapKit

final class BaseScrollView: UIScrollView {
    
    var contentView: UIView
    
    init(contentView: UIView = UIView().backgroundColor(.systemBackground)) {
        self.contentView = contentView
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .systemBackground
    }
    
    private func layout() {
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentLayoutGuide)
            make.width.equalTo(self)
            make.height.equalTo(self).priority(.low)
        }
    }
        
}
