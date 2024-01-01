//
//  MyInfoProfileView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit
import SnapKit
import Combine
import SDWebImage

final class MyInfoProfileView: BaseUIView {
        
    private let guestProfileImage = AppImage.defaultUserProfileImage.getImage()
    
    private lazy var profileImage = UIImageView()
        .setImage(guestProfileImage)
        .contentMode(.scaleAspectFill)
        .backgroundColor(AppUIColor.secondaryBlue)
        .shadow(color: .black, alpha: 0.2, x: 0.3, y: 0.3, blur: 1, spread: 1, radius: 1)
        .isHidden(true)
        .cornerRadius(30) as! UIImageView
    
    private lazy var profileNameLabel = ViewFactory
        .label("로그인하고 내 데이터를 관리해보세요.") // 프로필 이름
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(AppUIColor.label)
    
    private lazy var profileEmailBackground = ViewFactory.hStack()
        .addSubviews([UIView.spacer(),
                      profileEmail,
                      UIView.spacer()])
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .cornerRadius(8)
        .shadow()

    lazy var profileEmail = ViewFactory
        .label("로그인하기")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.secondaryLabel)
    
    private lazy var profileView = ViewFactory
        .vStack(subviews: [profileImage, profileNameLabel, profileEmailBackground])
        .spacing(8)
        .distribution(.fill)
        .alignment(.center)
    
    // MARK: - Init
    init() {
        super.init()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        setSuperViewHeight()
    }
 
    private func layout() {
        self.addSubview(profileView)

        // Profile View
        profileView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        profileEmail.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.horizontalEdges.equalTo(profileEmailBackground).inset(12)
        }
        
    }
    
    // MARK: - Set
    public func setProfileNameLabel(text: String) {
        self.profileNameLabel.text = text
    }
    
    public func setProfileEmailLabel(text: String) {
        self.profileEmail.text = text
    }
    
    public func setProfileImage(image: UIImage) {
        self.profileImage.image = image
    }
    
    public func setProfileImage(imageUrl: String) {
        let imageUrl = URL(string: imageUrl)
        
        self.profileImage.sd_setImage(with: imageUrl,
                                  placeholderImage: nil,
                                  options: [.progressiveLoad])
    }
    
    private func setSuperViewHeight() {
        let height = profileView.frame.height
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    // MARK: - Observe
    
    func updateUserProfile(_ profileData: MyInfoProfile) {
        
        guard AuthManager.shared.isSignIn.value == true else {
            setProfileNameLabel(text: "로그인하고 내 데이터를 관리해보세요.")
            profileImage.isHidden = true
            return
        }
        
        profileImage.isHidden = false
        setProfileNameLabel(text: profileData.name)
        setProfileEmailLabel(text: profileData.email)
        
        guard let imageUrl = profileData.imageUrl, !imageUrl.isEmpty else {
            let defaultImage = AppImage.defaultUserProfileImage.getImage()
            setProfileImage(image: defaultImage)
            return
        }
        
        setProfileImage(imageUrl: imageUrl)
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MyInfoProfileView_Previews: PreviewProvider {
    
    static let viewModel = MyInfoViewModel()
    static let view = MyInfoProfileView()
    static let userData = MyInfoProfile.examples.first!
    static let isLogin = true
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(width: 393, height: 150)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                AuthManager.shared.isSignIn.send(isLogin)
                view.updateUserProfile(userData)
            }
        }
    }
}
#endif
