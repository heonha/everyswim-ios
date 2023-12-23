//
//  ActivityIndicatorView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit

final class ActivityIndicatorView: UIView {
    
    let indicator: ActivityIndicator
    private let contentView = UIView()
    
    init(indicator: ActivityIndicator, withBackground: Bool) {
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

final class ActivityIndicator: UIActivityIndicatorView {
    
    init(style: UIActivityIndicatorView.Style = .medium, color: UIColor) {
        super.init(style: style)
        configure()
        setColor(color: color)
    }
    
    override init(style: UIActivityIndicatorView.Style = .medium) {
        super.init(style: style)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.hidesWhenStopped = true
    }
    
    // MARK: - Public
    public func setColor(color: UIColor = AppUIColor.primary) {
        self.color = color
    }
    
    public func show() {
        self.isHidden = false
        self.startAnimating()
    }
    
    public func hide() {
        self.isHidden = true
    }
    
}
