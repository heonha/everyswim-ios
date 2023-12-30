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
    
    private let viewModel: MyInfoViewModel
    
    // MARK: - Views
    private lazy var mainView = BaseScrollView()
    private lazy var contentView = mainView.contentView
    
    private let bottomSpacer = UIView.spacer()
    
    private lazy var headerView = MyInfoHeaderView(viewModel: viewModel)
    private lazy var profileView = MyInfoProfileView(viewModel: viewModel, parentVC: self)
    private lazy var buttonList = MyInfoButtonList(viewModel: viewModel, parentVC: self)
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
        configure()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        hideNavigationBar(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainView.scrollToTop()
        self.setNaviagationTitle(title: "내 정보")
        updateHealthTime()
    }
    
    // MARK: - Configure
    private func configure() {
        
    }
    
    // MARK: bind
    private func bind() {
        let input = MyInfoViewModel
            .Input(signOutTapPublisher: buttonList.getButton(type: .logout).tapPublisher())
        
        let output = viewModel.transform(input: input)
    }
    
}

// MARK: - Layout
extension MyInfoController {
    
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
        self.contentView.addSubview(bottomSpacer)
    }

    public func scrollToTop() {
        mainView.scrollToTop()
    }
        
}

// MARK: - Observe
extension MyInfoController {
    
    private func observe() {
        bindButtonsAction()
    }
    
    private func bindButtonsAction() {
        
        // Health State Cell
        observeFetchedHealthDate()
        observeButtonFetchHealthData()
    }
    
    /// 건강 데이터 동기화
    private func observeButtonFetchHealthData() {
        healthStateCell.getRefreshButton()
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.presentMessage(title: "건강데이터를 동기화합니다.\n(미구현)")
            }
            .store(in: &cancellables)
    }
    
    private func observeFetchedHealthDate() {
        viewModel.lastHealthUpdateDate
            .receive(on: DispatchQueue.main)
            .replaceNil(with: "--:--")
            .sink { [weak self] date in
                self?.healthStateCell.updateTimeLabel(dateString: date)
            }
            .store(in: &cancellables)
    }
    
    func updateHealthTime() {
        if let date = SwimDataStore.shared.lastUpdatedDate.value {
            healthStateCell.updateTimeLabel(dateString: date.toString(.timeWithoutSeconds))
        }
        
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MyInfoController_Previews: PreviewProvider {
    
    static let vc = MyInfoController(viewModel: viewModel)
    static let viewModel = MyInfoViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            vc
        }
    }
}
#endif
