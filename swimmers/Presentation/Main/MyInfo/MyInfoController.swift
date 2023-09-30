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
    private lazy var profileView = MyInfoProfileView()
    private lazy var buttonList = MyInfoButtonList(viewModel: viewModel)
    private lazy var healthStateCell = HealthKitAuthStateCell()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollToTop()
        self.navigationItem.title = "내 정보"
        hideNavigationBar(false)
    }
    
    private func configure() {
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
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
    
    func scrollToTop() {
        self.scrollView.scrollToTop()
    }
    
    private func bind() {
        buttonList.getButton(type: .syncHealth)
            .gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { _ in
                let vc = UIViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
        
        healthStateCell.getRefreshButton()
            .gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { _ in
                print("Health Refresh")
            }
            .store(in: &cancellables)
        
        buttonList.getButton(type: .totalRecord)
            .gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { _ in
                let historyVC = ActivityViewController()
                self.push(historyVC, animated: true)
            }
            .store(in: &cancellables)
        
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
