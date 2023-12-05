//
//  DashboardHeaderView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/4/23.
//

import UIKit
import SnapKit

final class DashboardHeaderView: UIView {
    
    private let viewModel: DashboardViewModel
    
    private lazy var title: UILabel = ViewFactory
        .label("반가워요")
        .font(.custom(.sfProBold, size: 16))
        .foregroundColor(UIColor.secondaryLabel)
        .contentHuggingPriority(.init(rawValue: 251), for: .vertical)
        .contentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)

    private let subtitle = ViewFactory
        .label("오늘도 화이팅 해볼까요?")
        .font(.custom(.sfProBold, size: 21))
    
    private lazy var profileImageView: UIImageView = UIImageView()
        .setSize(width: 56, height: 56)
        .contentMode(.scaleAspectFill)
        .cornerRadius(56 / 2)
        .backgroundColor(AppUIColor.secondaryBackground)
        .contentHuggingPriority(.init(251), for: .horizontal)
    
    private lazy var vstack: UIStackView = ViewFactory
        .vStack()
        .addSubviews([title, subtitle])
        .alignment(.fill)
        .spacing(8)

    private lazy var hstack = ViewFactory
        .hStack()
        .addSubviews([vstack, profileImageView])
    
    // MARK: - Init
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    /// 유저 프로필 데이터 셋업 (헤더)
    public func setProfileData() {
        let profile = viewModel.getUserProfile()
        self.title.text = "반가워요, \(profile.name)"
        
        if let imageUrlString = profile.imageUrl {
            let imageUrl = URL(string: imageUrlString)
            self.profileImageView.sd_setImage(with: imageUrl,
                                              placeholderImage: nil,
                                              options: [.progressiveLoad],
                                              completed: { (_, error, _, _) in
                if let error = error { return }
                
                self.layoutIfNeeded()
            })
        } else {
            let defaultProfileImage = UIImage()
            self.profileImageView.image = defaultProfileImage
        }
    }
    
    // MARK: - Layout
    private func layout() {
        layoutMainHStack()
        layoutProfileImageView()
    }
    
    private func layoutMainHStack() {
        self.addSubview(hstack)

        hstack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func layoutProfileImageView() {
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(56)
        }
        
    }
    
}

#if DEBUG
import SwiftUI

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            DashboardHeaderView(viewModel: DashboardViewModel())
        }
    }
}
#endif
