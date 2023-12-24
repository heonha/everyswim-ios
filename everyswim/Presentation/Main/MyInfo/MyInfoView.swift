//
//  MyInfoView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import UIKit
import SnapKit

final class MyInfoView: BaseScrollView {
    
    weak var parentVC: MyInfoController?
    private let viewModel: MyInfoViewModel
    private let bottomSpacer = UIView.spacer()
    
    private lazy var profileView = MyInfoProfileView(viewModel: viewModel)
    private lazy var buttonList = MyInfoButtonList(viewModel: viewModel)
    private lazy var healthStateCell = HealthKitAuthStateCell()

    // MARK: - Init
    init(viewModel: MyInfoViewModel, parentVC: MyInfoController) {
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
    private func layout() {
        layoutProfileView(dependency: contentView)
        layoutHealthStateCell(dependency: profileView)
        layoutButtonList(dependency: healthStateCell)
        layoutBottomSpacer()
    }

    // 버튼 리스트 Container
    private func layoutButtonList(dependency: UIView) {
        self.contentView.addSubview(buttonList)
        buttonList.snp.makeConstraints { make in
            make.top.equalTo(dependency.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self).inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    // 건강데이터 연동 상태 셀
    private func layoutHealthStateCell(dependency: UIView) {
        self.contentView.addSubview(healthStateCell)
        healthStateCell.snp.makeConstraints { make in
            make.top.equalTo(dependency.snp.bottom).offset(10)
            make.centerX.equalTo(contentView)
            make.height.equalTo(70)
            make.horizontalEdges.equalTo(self).inset(20)
        }
    }
    
    // 프로필 뷰
    private func layoutProfileView(dependency: UIView) {
        self.contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(dependency).offset(10)
            make.horizontalEdges.equalTo(contentView)
        }
    }
    
    // 최하단 스페이서
    private func layoutBottomSpacer() {
        self.contentView.addSubview(bottomSpacer)
    }
    
    // MARK: - Observe
    private func observe() {
        bindButtonsAction()
    }
    
    private func bindButtonsAction() {
        
        // Health State Cell
        observeButtonFetchHealthData()
        
        // Button List
        observeButtonAction(buttonType: .changeUserInfo, action: changeProfileAction)
        observeButtonAction(buttonType: .syncHealth, action: syncHealthAction)
        observeButtonAction(buttonType: .editChallange, action: editChallangeAction)
        observeButtonAction(buttonType: .searchForPool, action: buttonSearchForPool)
        observeButtonAction(buttonType: .logout, action: buttonLogout)
        observeButtonAction(buttonType: .deleteAccount, action: buttonsDeleteAccount)
        
        // Profile View
        observeTapGesture()
        observeUserProfile()
    }
    
    // MARK: - ObserveButtonActions
    private func observeButtonAction(buttonType: MyInfoButtonType, action: @escaping () -> Void) {
        buttonList.getButton(type: buttonType)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard self != nil else { return }
                action()
            }
            .store(in: &cancellables)
    }
    
    /// 프로필 변경 VC Present
    private func changeProfileAction() {
        let viewModel = SetProfileViewModel()
        let setProfileVC = SetProfileViewController(viewModel: viewModel, type: .changeProfile)
        self.parentVC?.present(setProfileVC, animated: true)
    }
    
    /// 건강 연동 창 VC Present
    private func syncHealthAction() {
        let vc = UIViewController()
        self.parentVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 목표 수정 VC Present
    private func editChallangeAction() {
        let vc = SetGoalViewController()
        self.parentVC?.present(vc, animated: true)
    }
    
    /// 건강 데이터 동기화
    private func observeButtonFetchHealthData() {
        healthStateCell.getRefreshButton()
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.parentVC?.presentMessage(title: "건강데이터를 동기화합니다.\n(미구현)")
            }
            .store(in: &cancellables)
    }
    
    private func buttonSearchForPool() {
        let regionSearchManager = RegionSearchManager()
        let locationManager = DeviceLocationManager()
        let viewModel = PoolMapViewModel(locationManager: locationManager, regionSearchManager: regionSearchManager)
        let vc = PoolListViewController(viewModel: viewModel)
        self.parentVC?.push(vc, animated: true)
    }
    
    private func buttonLogout() {
        self.presentSignOutAlert()
    }
    
    private func buttonsDeleteAccount() {
        let deleteVC = UserDeleteViewController()
        self.parentVC?.push(deleteVC, animated: true)
    }
    
    /// 로그아웃 알럿 Present
    private func presentSignOutAlert() {
        guard let parentVC = parentVC else { return }
        
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            self.viewModel.signOut()
            self.scrollToTop()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let actions = [logout, cancel]

        self.parentVC?.presentAlert(title: "알림",
                                    message: "로그아웃 하시겠습니까?",
                                    target: parentVC,
                                    action: actions)
    }
    
    private func observeTapGesture() {
        self.gesturePublisher(.tap())
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
                self.profileView.setProfileNameLabel(text: profileData.name)
                self.profileView.setProfileEmailLabel(text: profileData.email)
                
                guard let imageUrl = profileData.imageUrl, !imageUrl.isEmpty else {
                    let defaultImage = AppImage.defaultUserProfileImage.getImage()
                    self.profileView.setProfileImage(image: defaultImage)
                    return
                }
                
                self.profileView.setProfileImage(imageUrl: imageUrl)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MyInfoView_Previews: PreviewProvider {
    
    static let viewController = MyInfoController(viewModel: viewModel)
    static let viewModel = MyInfoViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
