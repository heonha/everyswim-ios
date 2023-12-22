//
//  LoadingIndicator.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit

final class LoadingIndicatorView: UIView {
    
    let indicator: LoadingIndicator
    private let contentView = UIView()
    
    init(indicator: LoadingIndicator, withBackground: Bool) {
        self.indicator = indicator
        super.init(frame: .zero)
        
        if withBackground {
            backgroundColor = .init(hex: "000000", alpha: 0.2)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalTo(contentView)
        }
    }
    
    func show() {
        self.isHidden = false
        indicator.show()
    }
    
    func hide() {
        self.isHidden = true
        indicator.hide()
    }
    
}

final class LoadingIndicator: UIActivityIndicatorView {
    
    init(style: UIActivityIndicatorView.Style = .medium, color: UIColor) {
        super.init(style: style)
        configure(color: color)
    }
    
    override init(style: UIActivityIndicatorView.Style = .medium) {
        super.init(style: style)
        self.configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(color: UIColor = AppUIColor.primary) {
        self.color = color
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
