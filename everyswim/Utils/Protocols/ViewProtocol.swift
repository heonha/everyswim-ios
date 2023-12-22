//
//  ViewProtocol.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/22/23.
//

import UIKit
import SnapKit

protocol ViewProtocol {
    
    var contentView: UIView { get }
    
    func configure()
    func layout()
    func layoutContentView(parent: UIView)
    
}

extension ViewProtocol {
    
    func layoutContentView(parent: UIView) {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
    }
    
}
