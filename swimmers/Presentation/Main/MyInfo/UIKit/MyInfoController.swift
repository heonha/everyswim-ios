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

    /// Super View
    /// - padding horizontal
    /// - background : BackgroundObject
    private lazy var profileHeaderView = MyInfoHeaderView(viewModel: viewModel)
    private let buttons: [UIView] = []
    private lazy var navigationButtonVStack = ViewFactory.vStack()
        .addSubviews(buttons)
        .distribution(.fillEqually)
        .alignment(.center)
    
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
        
    }
    
    private func layout() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(profileHeaderView)
        self.scrollView.addSubview(navigationButtonVStack)
        
        scrollView.isScrollEnabled = true
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
                
        profileHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
                        
        navigationButtonVStack.snp.makeConstraints { make in
            make.top.equalTo(profileHeaderView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(scrollView).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
