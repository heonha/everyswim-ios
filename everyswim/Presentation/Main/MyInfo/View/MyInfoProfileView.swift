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
    
    private let viewModel: MyInfoViewModel
    private weak var parentVC: MyInfoController?
        
    private let guestProfileImage = AppImage.defaultUserProfileImage.getImage()
    
    private lazy var profileImage = UIImageView()
        .setImage(guestProfileImage)
        .contentMode(.scaleAspectFill)
        .backgroundColor(AppUIColor.secondaryBlue)
        .shadow(color: .black, alpha: 0.2, x: 0.3, y: 0.3, blur: 1, spread: 1, radius: 1)
        .cornerRadius(30) as! UIImageView
    
    private lazy var profileNameLabel = ViewFactory
        .label(" ") // 프로필 이름
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(AppUIColor.label)
    
    private lazy var profileEmailBackground = ViewFactory.hStack()
        .addSubviews([UIView.spacer(),
                      profileEmail,
                      UIView.spacer()])
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .cornerRadius(8)
        .shadow()

    private lazy var profileEmail = ViewFactory
        .label("로그인하기")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.secondaryLabel)
    
    private lazy var profileView = ViewFactory
        .vStack(subviews: [profileImage, profileNameLabel, profileEmailBackground])
        .spacing(8)
        .distribution(.fill)
        .alignment(.center)
    
    // MARK: - Init
    init(viewModel: MyInfoViewModel, parentVC: MyInfoController?) {
        self.viewModel = viewModel
        self.parentVC = parentVC
        super.init()
        layout()
        observe()
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
    private func observe() {
        // Profile View
        observeTapGesture()
        observeUserProfile()
    }
    
    private func observeTapGesture() {
        profileEmail.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                let signInState = viewModel.getSessionState()
                print("DEBUG: Tap 세션상태 \(signInState)")
                if !signInState {
                    let signInVC = SignInViewController(viewModel: .init())
                    signInVC.modalPresentationStyle = .fullScreen
                    parentVC?.present(signInVC, animated: true)
                }
                
            }
            .store(in: &cancellables)
    }
    
    private func observeUserProfile() {
        viewModel.myinfoProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wrappedProfile in
                guard let self = self else { return }
                guard let profileData = wrappedProfile else { return }
                setProfileNameLabel(text: profileData.name)
                setProfileEmailLabel(text: profileData.email)
                
                guard let imageUrl = profileData.imageUrl, !imageUrl.isEmpty else {
                    let defaultImage = AppImage.defaultUserProfileImage.getImage()
                    setProfileImage(image: defaultImage)
                    return
                }
                
                setProfileImage(imageUrl: imageUrl)
            }
            .store(in: &cancellables)
    }
  
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MyInfoProfileView_Previews: PreviewProvider {
    
    static let viewModel = MyInfoViewModel()
    static let vc = MyInfoController(viewModel: viewModel)
    
    static var previews: some View {
        UIViewPreview {
            MyInfoProfileView(viewModel: viewModel, parentVC: vc)
        }
        .frame(height: 150)
    }
}
#endif
