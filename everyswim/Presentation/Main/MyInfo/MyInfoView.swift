//
//  MyInfoView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import Foundation

import UIKit
import SnapKit

final class MyInfoView: BaseScrollView {
    
    private let parentVC: MyInfoController!
    private let viewModel: MyInfoViewModel!
    private let bottomSpacer = UIView.spacer()
    
    private lazy var profileView = MyInfoProfileView(viewModel: viewModel, target: parentVC)
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
                self?.parentVC.present(setProfileVC, animated: true)
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
                self.parentVC.navigationController?.pushViewController(vc, animated: true)
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
                self.parentVC.present(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindButtonFetchHealthData() {
        // 헬스데이터 가져오기
        healthStateCell.getRefreshButton()
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.parentVC.presentMessage(title: "건강데이터를 동기화합니다.\n(미구현)")
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
                self.parentVC.push(vc, animated: true)
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
                self?.parentVC.push(deleteVC, animated: true)
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
            self.scrollToTop()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.parentVC.present(alert, animated: true)
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
