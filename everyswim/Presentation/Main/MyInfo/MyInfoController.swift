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
    
    private lazy var mainView = MyInfoView(viewModel: viewModel, parentVC: self)
    
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
    }
    
    // MARK: - Configure
    private func configure() {
        
    }

    // MARK: - Layout
    private func layout() {
        layoutScrollView()
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
        
}

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
