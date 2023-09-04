//
//  HomeHeaderView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/4/23.
//

import UIKit
import SnapKit

final class HomeHeaderView: UIView {
    
    private let viewModel: HomeRecordsViewModel
    
    private lazy var title = ViewFactory.label("반가워요, Heon Ha!")
        .font(.custom(.sfProBold, size: 16))
        .foregroundColor(UIColor.secondaryLabel)

    private let subtitle = ViewFactory.label("오늘도 화이팅 해볼까요?")
        .font(.custom(.sfProBold, size: 21))
    
    private lazy var profileImageView: UIImageView = {
        let profileImage = UIImage(named: "Avatar") ?? UIImage()
        let imageView = UIImageView(image: profileImage)
        imageView.frame.size = .init(width: 56, height: 56)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var vstack: UIStackView = {
        let vstack = ViewFactory.vStack(subviews: [title, subtitle], alignment: .fill)
            .setSpacing(8)
        return vstack
    }()
    
    private lazy var hstack = ViewFactory.hStack(subviews: [vstack, profileImageView])
    
    init(viewModel: HomeRecordsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        
        self.addSubview(hstack)

        title.setContentHuggingPriority(.init(251), for: .vertical)
        title.setContentCompressionResistancePriority(.init(751), for: .vertical)
        profileImageView.setContentHuggingPriority(.init(251), for: .horizontal)
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(80)
        }
        
        hstack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
 
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(56)
        }
    }
    
    
}
