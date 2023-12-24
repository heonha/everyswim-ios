//
//  BaseUIView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/23/23.
//

import UIKit
import SnapKit
import Combine

class BaseUIView: UIView {
    
    var cancellables = Set<AnyCancellable>()
    let contentView = UIView()
    
    // MARK: - Init
    init(backgroundColor: UIColor = .systemBackground) {
        super.init(frame: .zero)
        setBackgroundColor(backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    public func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    private func configureContentView() {
        self.contentView.backgroundColor = .clear
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentView()
    }
    
    private func layoutContentView() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
}
