//
//  MyInfoView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import UIKit
import SnapKit

final class MyInfoView: BaseScrollView {
    
    private weak var parentVC: MyInfoController?
    private let viewModel: MyInfoViewModel
    private let bottomSpacer = UIView.spacer()
    
    private lazy var headerView = MyInfoHeaderView(viewModel: viewModel)
    private lazy var profileView = MyInfoProfileView(viewModel: viewModel, parentVC: parentVC)
    private lazy var buttonList = MyInfoButtonList(viewModel: viewModel, parentVC: parentVC)
    private lazy var healthStateCell = HealthKitAuthStateCell()

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
    private func layout() {
        layoutHeaderView(dependency: contentView)
        layoutProfileView(dependency: headerView)
        layoutHealthStateCell(dependency: profileView)
        layoutButtonList(dependency: healthStateCell)
        layoutBottomSpacer()
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
        observeFetchedHealthDate()
        observeButtonFetchHealthData()
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
