//
//  MyInfoViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

final class MyInfoViewController: BaseViewController {
    
    private let viewModel: MyInfoViewModel
    
    private let excuteLogout = PassthroughSubject<Void, Never>()
    
    // MARK: - Views
    private lazy var mainView = BaseScrollView()
    private lazy var contentView = mainView.contentView
        
    private lazy var headerView = MyInfoHeaderView()
    private lazy var profileView = MyInfoProfileView()
    private lazy var buttonList = MyInfoButtonList()
    private lazy var healthStateCell = HealthKitAuthStateCell()
    
    // MARK: - INIT
    init(viewModel: MyInfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        hideNavigationBar(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainView.scrollToTop()
        self.setNaviagationTitle(title: "내 정보")
    }

}

// MARK: - Layout
extension MyInfoViewController {
    
    private func layout() {
        layoutScrollView()
        layoutHeaderView(dependency: contentView)
        layoutProfileView(dependency: headerView)
        layoutHealthStateCell(dependency: profileView)
        layoutButtonList(dependency: healthStateCell)
        layoutBottomSpacer()
    }
    
    // ScrollView (Root)
    private func layoutScrollView() {
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }

    private func layoutHeaderView(dependency: UIView) {
        self.contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(dependency).inset(10)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(contentView)
        }
    }
    
    // 프로필 뷰
    private func layoutProfileView(dependency: UIView) {
        self.contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(dependency.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView)
        }
    }
    
    // 버튼 리스트 Container
    private func layoutButtonList(dependency: UIView) {
        self.contentView.addSubview(buttonList)
        buttonList.snp.makeConstraints { make in
            make.top.equalTo(dependency.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(20)
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
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
    }

    // 최하단 스페이서
    private func layoutBottomSpacer() {
        let bottomSpacer = UIView.spacer()
        self.contentView.addSubview(bottomSpacer)
    }

    private func scrollToTop() {
        mainView.scrollToTop()
    }
        
}

// MARK: - Observe
extension MyInfoViewController {
    
    // MARK: bind
    // swiftlint:disable:next function_body_length
    private func bind() {
        let input = MyInfoViewModel
            .Input(tappedLogout: getButtonTapPublisher(.logout),
                   excuteLogout: excuteLogout.eraseToAnyPublisher(),
                   tappedLoginButton: profileView.tapPublisher(),
                   tappedHealthRefreshButton: healthStateCell.getRefreshButtonTapPublisher(),
                   tappedSearchPoolButtonTapPublisher: getButtonTapPublisher(.searchForPool),
                   tappedEditChallangeButtonPublisher: getButtonTapPublisher(.editChallange),
                   tappedChangeUserInfoButtonPublisher: getButtonTapPublisher(.changeUserInfo),
                   tappedDeleteAccountButtonPublisher: getButtonTapPublisher(.deleteAccount),
                   tappedNotValiableMessageButtonPublisher: getButtonTapPublisher(.sendContact)
            )
        
        let output = viewModel.transform(input: input)
        
        output.presentHealthDataUpdateAlert
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.presentMessage(title: "건강데이터를 동기화합니다.")
            }
            .store(in: &cancellables)
        
        output.healthDataUpdated
            .receive(on: RunLoop.main)
            .sink { [unowned self] date in
                self.healthStateCell.updateTimeLabel(dateString: date)
            }
            .store(in: &cancellables)
        
        output.pushSearchSwimPoolViewController
            .sink { [unowned self] _ in
                buttonSearchForPool()
            }
            .store(in: &cancellables)
        
        output.presentEditChallangeView
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                let vc = SetGoalViewController()
                self.present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        output.presentNotValiableMessage
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.presentMessage(title: "미구현")
            }
            .store(in: &cancellables)
        
        output.updateSignState
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.buttonList.layoutSubviews()
            }
            .store(in: &cancellables)
        
        output.presentLoginViewController
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.presentLoginViewController()
            }
            .store(in: &cancellables)
        
        output.presentLogoutAlert
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.presentSignOutAlert()
            }
            .store(in: &cancellables)
        
        output.presentChangeUserInfoView
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                presentChangeProfileView()
            }
            .store(in: &cancellables)
        
        output.pushDeleteAccountView
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                pushDeleteAccountView()
            }
            .store(in: &cancellables)
        
        output.profileUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                self?.profileView.updateUserProfile(profile)
            }
            .store(in: &cancellables)
        
        output.showLoadingIndicator
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.healthStateCell.showLoadingIndicator()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.healthStateCell.hideLoadingIndicator()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// buttonList 의 Button Tap Publisher를 가져옵니다.
    private func getButtonTapPublisher(_ type: MyInfoButtonType) -> AnyPublisher<Void, Never> {
        return buttonList.getButtonTapPublisher(type)
    }
    
    // MARK: - ObserveButtonActions
    
    /// 로그인 VC Present
    private func presentLoginViewController() {
        let viewModel = SignInViewModel()
        let loginVC = SignInViewController(viewModel: viewModel)
        self.present(loginVC, animated: true)
    }
    
    /// 프로필 변경 VC Present
    private func presentChangeProfileView() {
        let viewModel = SetProfileViewModel()
        let setProfileVC = SetProfileViewController(viewModel: viewModel, type: .changeProfile)
        self.present(setProfileVC, animated: true)
    }
    
    /// 목표 수정 VC Present
    private func editChallangeAction() {
        let vc = SetGoalViewController()
        present(vc, animated: true)
    }

    /// 수영장 찾기 VC Present
    private func buttonSearchForPool() {
        let regionSearchManager = RegionSearchManager()
        let locationManager = DeviceLocationManager.shared
        let viewModel = PoolViewModel(locationManager: locationManager, regionSearchManager: regionSearchManager)
        let vc = PoolSearchViewController(viewModel: viewModel)
        push(vc, animated: true)
    }
    
    /// 탈퇴하기 View Push
    private func pushDeleteAccountView() {
        let deleteVC = UserDeleteViewController()
        push(deleteVC, animated: true)
    }
    
    // MARK: - ETC
    /// 로그아웃 알럿 Present
    private func presentSignOutAlert() {
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            self.viewModel.signOut()
            self.scrollToTop()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let actions = [logout, cancel]
        
        self.presentAlert(title: "알림",
                          message: "로그아웃 하시겠습니까?",
                          target: self,
                          action: actions)
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MyInfoController_Previews: PreviewProvider {
    
    static let viewController = MyInfoViewController(viewModel: viewModel)
    static let viewModel = MyInfoViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
    }
}
#endif
