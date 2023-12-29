//
//  BaseTableView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit

final class BaseTableView: UITableView {
    
    let activityIndicator = ActivityIndicator(style: .medium)
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(activityIndicator)
        activityIndicator.setBackgroundColor()
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.edges.equalTo(self)
        }
    }
    
}

final class ScrollViewInTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.hideSeparate()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
