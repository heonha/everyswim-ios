//
//  BaseEmptyCollectionViewCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/26/23.
//

import UIKit

final class EmptyCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "EmptyCollectionViewCell"
    
    private let titleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProMedium, size: 16))
        .numberOfLines(0)
        .foregroundColor(.secondaryLabel)
        .textAlignemnt(.center)

    init() {
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
        self.backgroundColor = .clear
    }
    
    public func setTitle(_ title: String,
                         font: UIFont = .custom(.sfProMedium, size: 16)) {
        self.titleLabel.text = title
        self.titleLabel.font = font
    }

    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.center.equalTo(contentView)
        }
    }
    
}
