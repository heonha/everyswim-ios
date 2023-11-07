//
//  MediaCollectionViewHeader.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/6/23.
//

import UIKit

class MediaCollectionViewHeader: UICollectionReusableView, ReuseableObject {
    
    static var reuseId: String = "MediaCollectionViewHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(20)
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
}
