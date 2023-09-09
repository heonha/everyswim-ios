//
//  ImageSliderCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/9/23.
//

import UIKit
import SnapKit

class ImageSliderCell: UICollectionViewListCell {
        
    
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
        .setSpacing(6)
    
    var imageView: UIImageView = {
        let iv = UIImageView(frame: .zero)

        iv.layer.cornerRadius = 16
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
        
        self.addSubview(imageView)
        imageView.addSubview(foregroundLayer)
        imageView.addSubview(labelVStack)

        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalToSuperview().inset(4)
        }
        
        foregroundLayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        labelVStack.snp.makeConstraints { make in
            make.leading.equalTo(imageView).offset(8)
            make.top.equalTo(imageView).offset(8)
            make.trailing.equalTo(imageView).offset(-8)

        }
        
    }
}


// ZStack {
//     Color.black.opacity(0.5)
//         .overlay(alignment: .topLeading) {
//             VStack(alignment: .leading, spacing: 8) {
//                 Text(title)
//                     .font(.custom(.sfProBold, size: 25))
//                     .foregroundColor(.white)
//                     .padding(.top)
//                 
//                 Text(subtitle)
//                     .font(.custom(.sfProMedium, size: 18))
//                     .foregroundColor(.white)
//             }
//             .padding()
//         }
// }
