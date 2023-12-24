//
//  MyInfoController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

final class MyInfoController: BaseViewController {

    private let viewModel = MyInfoViewModel()
    private let scrollView = BaseScrollView()
    private let bottomSpacer = UIView.spacer()
    
    private lazy var profileView = MyInfoProfileView(viewModel: viewModel,
                                                     target: self)
    private lazy var buttonList = MyInfoButtonList(viewModel: viewModel)
    private lazy var healthStateCell = HealthKitAuthStateCell()
    
    // MARK: - INIT & Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        hideNavigationBar(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bindButtonsAction()
        scrollView.scrollToTop()
        self.navigationItem.title = "내 정보"
    }
    
    // MARK: - Configure
    private func configure() {
        
    }

    // MARK: - Layout
    private func layout() {
        layoutScrollView()
        layoutProfileView(dependency: scrollView.contentView)
        layoutHealthStateCell(dependency: profileView)
        layoutButtonList(dependency: healthStateCell)
        layoutBottomSpacer()
    }
    
    // ScrollView (Root)
    private func layoutScrollView() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 버튼 리스트 Container
    private func layoutButtonList(dependency: UIView) {
        self.scrollView.contentView.addSubview(buttonList)
        buttonList.snp.makeConstraints { make in
            make.top.equalTo(dependency.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(scrollView).inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    // 건강데이터 연동 상태 셀
    private func layoutHealthStateCell(dependency: UIView) {
        self.scrollView.contentView.addSubview(healthStateCell)
        healthStateCell.snp.makeConstraints { make in
            make.top.equalTo(dependency.snp.bottom).offset(10)
            make.centerX.equalTo(scrollView.contentView)
            make.height.equalTo(70)
            make.horizontalEdges.equalTo(scrollView).inset(20)
        }
    }
    
    // 프로필 뷰
    private func layoutProfileView(dependency: UIView) {
        self.scrollView.contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(dependency).offset(10)
            make.horizontalEdges.equalTo(scrollView.contentView)
        }
    }
    
    // 최하단 스페이서
    private func layoutBottomSpacer() {
        self.scrollView.contentView.addSubview(bottomSpacer)
    }
    
    // MARK: - Bind Buttons
    private func bindButtonsAction() {
        bindChangeProfileAction()
        bindSyncHealthAction()
        bindEditChallangeAction()
        bindButtonFetchHealthData()
        bindButtonSearchForPool()
        bindButtonLogout()
        bindButtonsDeleteAccount()
    }
    
    func bindChangeProfileAction() {
        // 프로필 변경
        buttonList.getButton(type: .changeUserInfo)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let viewModel = SetProfileViewModel()
                let setProfileVC = SetProfileViewController(viewModel: viewModel, type: .changeProfile)
                self?.present(setProfileVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindSyncHealthAction() {
        // 건강 연동
        buttonList.getButton(type: .syncHealth)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let vc = UIViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindEditChallangeAction() {
        // 목표 수정
        buttonList.getButton(type: .editChallange)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let vc = SetGoalViewController()
                self.present(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindButtonFetchHealthData() {
        // 헬스데이터 가져오기
        healthStateCell.getRefreshButton()
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.presentMessage(title: "건강데이터를 동기화합니다.\n(미구현)")
            }
            .store(in: &cancellables)
    }
    
    private func bindButtonSearchForPool() {
        // 맵 뷰
        buttonList.getButton(type: .searchForPool)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let regionSearchManager = RegionSearchManager()
                let locationManager = DeviceLocationManager()
                let viewModel = PoolMapViewModel(locationManager: locationManager, regionSearchManager: regionSearchManager)
                let vc = PoolListViewController(viewModel: viewModel)
                self.push(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindButtonLogout() {
        // 로그아웃
        buttonList.getButton(type: .logout)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentSignOutAlert()
            }
            .store(in: &cancellables)
    }
    
    private func bindButtonsDeleteAccount() {
        // 탈퇴
        buttonList.getButton(type: .deleteAccount)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let deleteVC = UserDeleteViewController()
                self?.push(deleteVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func presentSignOutAlert() {
        let alert = UIAlertController(title: "알림", 
                                      message: "로그아웃 하시겠습니까?",
                                      preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "로그아웃",
                                         style: .destructive) { _ in
            self.viewModel.signOut()
            self.scrollView.scrollToTop()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
}

#if DEBUG
import SwiftUI

struct MyInfoController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MyInfoController()
        }
    }
}
#endif
