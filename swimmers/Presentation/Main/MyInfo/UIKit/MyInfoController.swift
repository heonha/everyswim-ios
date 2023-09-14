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
    
    /// VStack
    /// - header padding 8
    private lazy var profileHeaderView = MyInfoHeaderView(viewModel: viewModel)
    private let headerView = UIView()
    private let profileView = UIView()
    
    private let buttons: [UIView] = []
    private lazy var navigationButtonVStack = UIStackView()
    
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
        
    }
    
    private func bind() {
        
    }
    
    // HStack {
    //     ZStack {
    //         RoundedRectangle(cornerRadius: 8)
    //             .fill(.regularMaterial)
    // 
    //         Text("수력 4년차")
    //             .font(.custom(.sfProBold, size: 14))
    //             .foregroundColor(.init(uiColor: .label))
    //     }
    //     .frame(width: 74, height: 36)
    //     
    //     Spacer()
    //     
    //     Button {
    //         print("프로필편집")
    //     } label: {
    //         ZStack {
    //             RoundedRectangle(cornerRadius: 8)
    //                 .fill(.ultraThinMaterial)
    //                 .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 1)
    //             
    //             Image(systemName: "pencil")
    //                 .font(.system(size: 17))
    //                 .foregroundColor(Color(hex: "7E7E7E"))
    //         }
    //     }
    //     .frame(width: 20, height: 20)
    //     
    // }
    
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
