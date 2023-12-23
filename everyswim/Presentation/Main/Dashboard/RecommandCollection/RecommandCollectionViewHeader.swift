//
//  RecommandCollectionViewHeader.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/6/23.
//

import UIKit
import SnapKit

class RecommandCollectionViewHeader: UICollectionReusableView, ReuseableCell {
    
    static var reuseId: String = "RecommandCollectionViewHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(.sfProBold, size: 18)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(.sfProMedium, size: 14)
        label.textColor = AppUIColor.secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var vstack = ViewFactory.vStack()
        .addSubviews([titleLabel, subtitleLabel])
        .alignment(.leading)
        .distribution(.fillProportionally)
        .spacing(4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(20)
        }

    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
}
