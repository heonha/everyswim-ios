//
//  CommunityReusableCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/8/23.
//

import UIKit
import SnapKit
import SDWebImage
import Combine

class CommunityReusableCell: UICollectionViewListCell, ReuseableObject, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    static let reuseId: String = "CommunityReusableCell"
    
    private var titleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProMedium, size: 14))
        .foregroundColor(AppUIColor.label)
    
    private var subtitleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProLight, size: 12))
        .foregroundColor(AppUIColor.secondaryLabel)
    
    private lazy var labelVStack = ViewFactory
        .hStack(subviews: [titleLabel, subtitleLabel], spacing: 2)
        .alignment(.top)
        .setEdgeInset(NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
    
    private var imageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    private var foregroundLayer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true

        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        contentView.addSubview(imageView)
        contentView.addSubview(labelVStack)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        imageView.addSubview(foregroundLayer)
        
        foregroundLayer.snp.makeConstraints { make in
            make.size.equalTo(imageView)
        }
        
        labelVStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(contentView)
        }
    }
    
    func configure(viewModel: RecommandCollectionProtocol) {
        let url = URL(string: viewModel.imageUrl)
        let placeholderImage = UIImage(named: "photo")
        self.imageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        
        if let title = viewModel.title {
            self.titleLabel.text = title
        }
        
        if let subtitle = viewModel.subtitle {
            self.subtitleLabel.text = subtitle
        }
        
        self.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let url = URL.init(string: viewModel.url)!
                UIApplication.shared.open(url)
            }
            .store(in: &cancellables)
    }
    
}