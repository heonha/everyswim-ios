//
//  RecommandCollectionCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/9/23.
//

import UIKit
import SnapKit

class RecommandCollectionCell: UICollectionViewListCell, ReuseableObject {
    
    static let reuseId: String = "MediaCollectionCell"
    
    var titleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProBold, size: 22))
        .foregroundColor(.white)
    
    var subtitleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProMedium, size: 16))
        .foregroundColor(.white)
    
    lazy var labelVStack = ViewFactory
        .vStack(subviews: [titleLabel, subtitleLabel], spacing: 8)
        .setEdgeInset(NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
    
    var imageView: UIImageView = {
        let iv = UIImageView(frame: .zero)

        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var foregroundLayer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelVStack)
        
        imageView.addSubview(foregroundLayer)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(180)
            make.top.equalToSuperview().inset(4)
        }
        
        foregroundLayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        labelVStack.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.contentView)
        }
        
    }
}
