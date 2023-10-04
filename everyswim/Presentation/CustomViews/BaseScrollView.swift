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
    private var inset: UIEdgeInsets
    
    init(contentView: UIView = UIView().backgroundColor(.systemBackground),
         inset: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
        self.contentView = contentView
        self.inset = inset
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
            make.edges.equalTo(self.contentLayoutGuide).inset(inset)
            make.width.equalTo(self)
            make.height.equalTo(self).priority(.low)
        }
    }
    
    func scrollToTop() {
        setContentOffset(CGPoint(x: 0, y: contentView.frame.minY), animated: true)
    }
        
}
