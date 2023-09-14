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
        .shadow(color: .black, alpha: 0.1, x: 0.3, y: 0.3, blur: 1)

    private lazy var imageView = UIImageView()
        .contentMode(.scaleAspectFit)
        .setSymbolImage(systemName: "pencil",
                        color: UIColor(hex: "7E7E7E"))
        .disableUserInteraction(true)
    
    private lazy var editProfile = UIButton()
        .cornerRadius(6)
        .subview(imageView)
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .shadow(color: .black, alpha: 0.1, x: 0.3, y: 0.3, blur: 1)

    private lazy var mainHStack = ViewFactory
        .hStack(subviews: [headerView, UIView.spacer(), editProfile])
        .distribution(.equalSpacing)
    
    private lazy var profileImage = UIImageView()
        .setImage(.init(named: "Avatar"))
        .contentMode(.scaleAspectFit)
        .shadow(color: .black, alpha: 0.2, x: 0.3, y: 0.3, blur: 1, spread: 1, radius: 1)
        .cornerRadius(30)
    
    private lazy var profileTitle = ViewFactory
        .label("Heon Ha")
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(.label)
    
    private lazy var profileEmailBackground = ViewFactory.hStack()
        .addSubviews([UIView.spacer(),
                      profileEmail,
                      UIView.spacer()])
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .cornerRadius(8)
    
    private lazy var profileEmail = ViewFactory
        .label("heonha@heon.dev")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.secondaryLabel)

    private lazy var profileView = ViewFactory
        .vStack(subviews: [profileImage, profileTitle, profileEmailBackground])
        .distribution(.fill)
        .alignment(.center)
    
    init(viewModel: MyInfoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        observe()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSuperViewSize()
    }
    
    private func observe() {
        
    }
    
    private func layout() {
        
        self.addSubview(mainHStack)
        self.addSubview(profileView)
        
        headerTitle.snp.makeConstraints { make in
            make.center.equalTo(headerView)
        }
        
        headerView.snp.makeConstraints { make in
            make.width.equalTo(76)
            make.height.equalTo(40)
        }
        
        editProfile.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.center.equalTo(editProfile)
        }
        
        mainHStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        // Profile View
        profileView.snp.makeConstraints { make in
            make.top.equalTo(mainHStack.snp.bottom).offset(16)
            make.centerX.equalTo(self)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        profileEmail.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(24)
            make.horizontalEdges.equalTo(profileEmailBackground).inset(12)
        }
                
    }
    
    private func setSuperViewSize() {
        self.snp.makeConstraints { make in
            make.height.equalTo(mainHStack.frame.height + profileView.frame.height + 20)
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
        .frame(height: 300)
        .border(.black.opacity(0.3), width: 0.5)
    }
}
#endif

