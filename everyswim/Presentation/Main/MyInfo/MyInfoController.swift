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

final class MyInfoController: UIViewController {

    private let viewModel = MyInfoViewModel()
    private let scrollView = BaseScrollView()
    private let bottomSpacer = UIView.spacer()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var headerView = MyInfoHeaderView(viewModel: viewModel)
    private lazy var profileView = MyInfoProfileView(viewModel: viewModel, target: self)
    private lazy var buttonList = MyInfoButtonList(viewModel: viewModel)
    private lazy var healthStateCell = HealthKitAuthStateCell()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
        layout()
        bindButtonsAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollToTop()
        hideNavigationBar(false)
        self.navigationItem.title = "내 정보"
    }
    
    private func configure() {
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func scrollToTop() {
        self.scrollView.scrollToTop()
    }
    
    private func layout() {
        self.view.addSubview(scrollView)
        
        self.scrollView.contentView.addSubview(headerView)
        self.scrollView.contentView.addSubview(profileView)
        self.scrollView.contentView.addSubview(healthStateCell)
        self.scrollView.contentView.addSubview(buttonList)
        self.scrollView.contentView.addSubview(bottomSpacer)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
                
        headerView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentView)
            make.horizontalEdges.equalTo(scrollView.contentView)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(scrollView.contentView)
        }
        
        healthStateCell.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.centerX.equalTo(scrollView.contentView)
            make.height.equalTo(70)
            make.horizontalEdges.equalTo(scrollView).inset(20)
        }
                        
        buttonList.snp.makeConstraints { make in
            make.top.equalTo(healthStateCell.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(scrollView).inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    

    
    private func bindButtonsAction() {
        
        // 프로필 변경
        buttonList.getButton(type: .changeUserInfo)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let setProfileVC = SetProfileViewController()
                self?.present(setProfileVC, animated: true)
            }
            .store(in: &cancellables)
        
        // 건강 연동
        buttonList.getButton(type: .syncHealth)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let vc = UIViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
        
        // 목표 수정
        buttonList.getButton(type: .editChallange)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let vc = SetGoalViewController()
                self.present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        // 헬스데이터 가져오기
        healthStateCell.getRefreshButton()
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("Health Refresh")
            }
            .store(in: &cancellables)
        
        // 로그아웃
        buttonList.getButton(type: .logout)
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentSignOutAlert()
            }
            .store(in: &cancellables)

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
            self.scrollToTop()
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
