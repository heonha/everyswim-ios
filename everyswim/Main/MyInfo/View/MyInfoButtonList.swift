//
//  MyInfoButtonList.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit
import Combine

final class MyInfoButtonList: BaseUIView {

    private let viewModel: MyInfoViewModel
    private weak var parentVC: MyInfoController?
    
    private lazy var buttons: [MyInfoButton] = viewModel
        .getButtonListData()
        .map { MyInfoButton($0) }
    
    private lazy var firstSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter { $0.getSection() == .first })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    private lazy var secondSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter { $0.getSection() == .second })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    private lazy var thirdSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter { $0.getSection() == .third })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
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
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        observeLogInState()
    }
    
    private func observeLogInState() {
        viewModel.isSignInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] signIn in
                self?.switchVisableIconsFromSignInState(signIn: signIn)
            }
            .store(in: &cancellables)
    }
    
    private func switchVisableIconsFromSignInState(signIn: Bool) {
        let logoutbutton = self.getButton(type: .logout)
        let changeInfo = self.getButton(type: .changeUserInfo)
        let deleteAccount = self.getButton(type: .deleteAccount)

        let buttons = [logoutbutton, changeInfo, deleteAccount]
        buttons.forEach { $0.isHidden = !signIn }
    }
    
    // MARK: - Layout
    private func layout() {
        contentView.backgroundColor = AppUIColor.whithThickMaterialColor
        contentView.addSubview(firstSectionView)
        contentView.addSubview(secondSectionView)
        contentView.addSubview(thirdSectionView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        firstSectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.top.equalTo(contentView).inset(20)
        }
        
        secondSectionView.snp.makeConstraints { make in
            make.top.equalTo(firstSectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(12)
        }

        thirdSectionView.snp.makeConstraints { make in
            make.top.equalTo(secondSectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView).inset(20)
        }
    }

    func getButton(type: MyInfoButtonType) -> MyInfoButton {
        let button = self.buttons.first { infoButton in
            return type == infoButton.getType()
        }
        
        if let button = button {
            return button
        } else {
            return MyInfoButton(.setupAlert)
        }
    }
    
    func getAllButton() -> [MyInfoButton] {
        return self.buttons
    }
    
    // MARK: - Observe
    func observe() {
        // Button List
        observeButtonAction(buttonType: .changeUserInfo, action: changeProfileAction)
        observeButtonAction(buttonType: .syncHealth, action: syncHealthAction)
        observeButtonAction(buttonType: .editChallange, action: editChallangeAction)
        observeButtonAction(buttonType: .searchForPool, action: buttonSearchForPool)
        observeButtonAction(buttonType: .logout, action: buttonLogout)
        observeButtonAction(buttonType: .deleteAccount, action: buttonsDeleteAccount)
        
        observeButtonAction(buttonType: .shareApp, action: presentShareAppAlert)
        observeButtonAction(buttonType: .setupAlert, action: presentNotificationView)
        observeButtonAction(buttonType: .sendContact, action: presentContactDeveloper)
        observeButtonAction(buttonType: .questions, action: presentHelp)
    }
    
    // MARK: - ObserveButtonActions
    private func observeButtonAction(buttonType: MyInfoButtonType, action: @escaping () -> Void) {
        getButton(type: buttonType)
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
        parentVC?.presentMessage(title: "미구현(건강 미연동 시 사용)")
    }
    
    /// 목표 수정 VC Present
    private func editChallangeAction() {
        let vc = SetGoalViewController()
        self.parentVC?.present(vc, animated: true)
    }

    /// 수영장 찾기 VC Present
    private func buttonSearchForPool() {
        let regionSearchManager = RegionSearchManager()
        let locationManager = DeviceLocationManager.shared
        let viewModel = PoolViewModel(locationManager: locationManager, regionSearchManager: regionSearchManager)
        let vc = PoolSearchViewController(viewModel: viewModel)
        self.parentVC?.push(vc, animated: true)
    }

    /// 앱 공유하기 알럿을 띄웁니다.
    private func presentShareAppAlert() {
        parentVC?.presentMessage(title: "미구현(앱 공유하기)")
    }
    
    /// 알림설정 알럿을 띄웁니다.
    private func presentNotificationView() {
        parentVC?.presentMessage(title: "미구현(알림 설정)")
    }
    
    /// 문의보내기 알럿을 띄웁니다.
    private func presentContactDeveloper() {
        parentVC?.presentMessage(title: "미구현(문의 보내기)")
    }
    
    /// 도움말 VC를 띄웁니다.
    private func presentHelp() {
        parentVC?.presentMessage(title: "미구현(도움말)")
    }
    
    /// 로그아웃
    private func buttonLogout() {
        self.presentSignOutAlert()
    }
    
    /// 탈퇴
    private func buttonsDeleteAccount() {
        let deleteVC = UserDeleteViewController()
        self.parentVC?.push(deleteVC, animated: true)
    }
    
    // MARK: - ETC
    
    /// 로그아웃 알럿 Present
    private func presentSignOutAlert() {
        guard let parentVC = parentVC else { return }
        
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            self.viewModel.signOut()
            self.parentVC?.scrollToTop()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let actions = [logout, cancel]

        self.parentVC?.presentAlert(title: "알림",
                                    message: "로그아웃 하시겠습니까?",
                                    target: parentVC,
                                    action: actions)
    }
        
}

#if DEBUG
import SwiftUI

struct MyInfoButtonList_Previews: PreviewProvider {
    
    static let parentVC = MyInfoController(viewModel: viewModel)
    static let viewModel = MyInfoViewModel()
    
    static var previews: some View {
        UIViewPreview {
            MyInfoButtonList(viewModel: viewModel, parentVC: parentVC)
        }
    }
}
#endif
