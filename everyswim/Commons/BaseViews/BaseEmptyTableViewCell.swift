//
//  BaseEmptyTableViewCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import UIKit
import SnapKit

final class BaseEmptyTableViewCell: UITableViewCell {
    
    private let titleLabel = ViewFactory
        .label("결과가 없습니다.")
        .font(.custom(.sfProMedium, size: 16))
        .numberOfLines(0)
        .foregroundColor(.secondaryLabel)
        .textAlignemnt(.center)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    public func setTitle(_ title: String,
                         font: UIFont = .custom(.sfProMedium, size: 16)) -> BaseEmptyTableViewCell {
        self.titleLabel.text = title
        self.titleLabel.font = font
        return self
    }
    
    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.center.equalTo(contentView)
        }
    }
    
}
