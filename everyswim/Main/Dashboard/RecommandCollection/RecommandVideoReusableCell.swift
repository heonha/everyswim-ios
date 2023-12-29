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

class RecommandVideoReusableCell: UICollectionViewListCell, ReuseableCell {
    
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
        .setEdgeInset(.all(6))
    
    private var imageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemFill
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
            make.edges.equalTo(contentView)
            make.height.equalTo(contentView)
        }
        
        imageView.addSubview(foregroundLayer)
        
        foregroundLayer.snp.makeConstraints { make in
            make.size.equalTo(imageView)
        }

    }
    
    func setData(data: RecommandCollectionProtocol) {
        let url = URL(string: data.imageUrl)
        self.imageView.sd_setImage(with: url)
        
        if let title = data.title {
            self.titleLabel.text = title
        }
        
        if let subtitle = data.subtitle {
            self.subtitleLabel.text = subtitle
        }
        
        self.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                guard let url = URL.init(string: data.url) else { return }
                UIApplication.shared.open(url)
            }
            .store(in: &cancellables)
    }

}

#if DEBUG
import SwiftUI

struct RecommandVideoReusableCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DashboardViewController()
        }
        .ignoresSafeArea()
    }
}
#endif
