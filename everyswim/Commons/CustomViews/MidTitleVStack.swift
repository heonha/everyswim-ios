//
//  MidTitleVStack.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/15/23.
//

import UIKit
import SnapKit

final class MidTitleVStack: UIView {
    
    private let title: String
    private let subtitle: String
    
    private lazy var titleLabel = ViewFactory
        .label(title)
        .font(.custom(.sfProBold, size: 24))
    
    private lazy var subtitleLabel = ViewFactory
        .label(subtitle)
        .font(.custom(.sfProLight, size: 18))
    
    private lazy var stackView = ViewFactory.vStack()
        .addSubviews([titleLabel, subtitleLabel])
        .spacing(8)
        .distribution(.fillProportionally)
        .alignment(.center)
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        super.init(frame: .zero)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
    }
    
}
