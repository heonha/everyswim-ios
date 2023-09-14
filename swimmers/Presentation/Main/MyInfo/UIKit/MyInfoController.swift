//
//  MyInfoController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

final class MyInfoController: UIViewController {

    private let viewModel = MyInfoViewModel()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView().backgroundColor(.white)
    private let bottomSpacer = UIView.spacer()
    
    private lazy var profileHeaderView = MyInfoHeaderView(viewModel: viewModel)
    private lazy var navigationButtonVStack = MyInfoButtonList(viewModel: viewModel)
    
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
        scrollView.addSubview(scrollContentView)
        self.scrollContentView.addSubview(profileHeaderView)
        self.scrollContentView.addSubview(navigationButtonVStack)
        self.scrollContentView.addSubview(bottomSpacer)
        
        scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView).priority(.low)
        }
                
        profileHeaderView.snp.makeConstraints { make in
            make.top.equalTo(scrollContentView)
            make.horizontalEdges.top.equalTo(scrollContentView).inset(8)
        }
                        
        navigationButtonVStack.snp.makeConstraints { make in
            make.top.equalTo(profileHeaderView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(scrollView).inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func bind() {
        
    }
    
}

#if DEBUG
import SwiftUI

struct MyInfoController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MyInfoController()
        }
        .ignoresSafeArea()
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
