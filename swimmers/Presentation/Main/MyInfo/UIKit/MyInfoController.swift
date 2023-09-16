//
//  MyInfoController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit
import Combine

final class MyInfoController: UIViewController {

    private let viewModel = MyInfoViewModel()
    private let scrollView = BaseScrollView()
    private let bottomSpacer = UIView.spacer()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var headerView = MyInfoHeaderView(viewModel: viewModel)
    private lazy var buttonList = MyInfoButtonList(viewModel: viewModel)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func layout() {
        self.view.addSubview(scrollView)
        self.scrollView.contentView.addSubview(headerView)
        self.scrollView.contentView.addSubview(buttonList)
        self.scrollView.contentView.addSubview(bottomSpacer)
        
        scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
                
        headerView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentView)
            make.horizontalEdges.top.equalTo(scrollView.contentView).inset(8)
        }
                        
        buttonList.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(scrollView).inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func bind() {
        buttonList.getButton(type: .syncHealth)
            .gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { _ in
                let vc = UIViewController(backgroundColor: .systemBackground)
                self.navigationController?.pushViewController(vc, animated: true)
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

#if DEBUG
import SwiftUI

struct MyInfoViewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoViewSwiftUI()
    }
}
#endif
