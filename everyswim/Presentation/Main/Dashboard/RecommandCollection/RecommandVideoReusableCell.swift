//
//  RecommandVideoReusableCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/9/23.
//

import UIKit
import SnapKit
import SDWebImage
import Combine

class RecommandVideoReusableCell: UICollectionViewListCell, ReuseableObject, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    static let reuseId: String = "RecommandCollectionCell"
    
    private var titleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProBold, size: 22))
        .foregroundColor(.white)
    
    private var subtitleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProMedium, size: 16))
        .foregroundColor(.white)
    
    private lazy var labelVStack = ViewFactory
        .vStack(subviews: [titleLabel, subtitleLabel], spacing: 8)
        .setEdgeInset(NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
    
    private var imageView: UIImageView = {
        let iv = UIImageView(frame: .zero)

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
            make.center.equalTo(contentView)
            make.height.equalTo(contentView)
        }
        
        imageView.addSubview(foregroundLayer)
        
        foregroundLayer.snp.makeConstraints { make in
            make.size.equalTo(imageView)
        }
        
        labelVStack.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.contentView)
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