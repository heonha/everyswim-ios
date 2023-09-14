//
//  MyInfoHeaderView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

final class MyInfoHeaderView: UIView {
    
    private let viewModel: MyInfoViewModel
    
    private var headerTitle = ViewFactory.label("수력 4년차")
        .font(.custom(.sfProBold, size: 12))
        .foregroundColor(.label)
    
    private lazy var headerView = UIView()
        .cornerRadius(6)
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .subview(headerTitle)

    private lazy var imageView = UIImageView()
        .contentMode(.scaleAspectFit)
        .setSymbolImage(systemName: "pencil",
                        color: UIColor(hex: "7E7E7E"))
        .disableUserInteraction(true)
    
    private lazy var editProfile = UIButton()
        .cornerRadius(6)
        .subview(imageView)
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
            
    private lazy var mainHStack = ViewFactory
        .hStack(subviews: [headerView, UIView.spacer(), editProfile])
        .distribution(.equalSpacing)    
    
    init(viewModel: MyInfoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        
        self.addSubview(mainHStack)
        
        headerTitle.snp.makeConstraints { make in
            make.center.equalTo(headerView)
        }
        
        headerView.snp.makeConstraints { make in
            make.width.equalTo(76)
            make.height.equalTo(40)
        }
        
        editProfile.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(17)
            make.center.equalTo(editProfile)
        }
        
        mainHStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
}

#if DEBUG
import SwiftUI

struct MyInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            MyInfoHeaderView(viewModel: MyInfoViewModel())
        }
        .frame(width: Constant.deviceSize.width, height: 80)
        .background(Color.blue)
    }
}
#endif

