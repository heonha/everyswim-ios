//
//  MyInfoHeaderView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

final class MyInfoHeaderView: BaseUIView {
        
    // MARK: - Views
    private var levelLabel = ViewFactory
        .label("Level 1")
        .font(.custom(.sfProBold, size: 12))
        .foregroundColor(AppUIColor.label)
    
    private lazy var levelView = UIView()
        .cornerRadius(6)
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .subview(levelLabel)
        .shadow(color: .black, alpha: 0.1, x: 0.3, y: 0.3, blur: 1)

    private lazy var headerBar = ViewFactory
        .hStack(subviews: [levelView, UIView.spacer()])
        .distribution(.equalSpacing)
        .alignment(.center)
    
    // MARK: - Init
    init() {
        super.init()
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    private func configure() {
        
    }
    
    // MARK: - Layout
    private func layout() {
        layoutHeaderBar()
        layoutLevelView()
    }

    private func layoutHeaderBar() {
        contentView.addSubview(headerBar)
        headerBar.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func layoutLevelView() {
        // Header Bar Items
        levelView.snp.makeConstraints { make in
            make.leading.equalTo(headerBar)
            make.centerY.equalTo(headerBar)
            make.height.equalTo(24)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.center.equalTo(levelView)
            make.size.equalTo(levelView).inset(4)
        }
    }
    
}

#if DEBUG
import SwiftUI

struct MyInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            MyInfoHeaderView()
        }
    }
}
#endif
