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
    
    private var swimYearsLabel = ViewFactory.label("수력 4년차")
        .font(.custom(.sfProBold, size: 12))
        .foregroundColor(.label)
    
    private lazy var swimYearsView = UIView()
        .cornerRadius(6)
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .subview(swimYearsLabel)
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

    private lazy var headerBar = ViewFactory
        .hStack(subviews: [swimYearsView, UIView.spacer(), editProfile])
        .distribution(.equalSpacing)
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
    }
    
    private func observe() {
        
    }
    
    private func layout() {
        
        self.addSubview(headerBar)
        
        // Header Bar Items
        swimYearsView.snp.makeConstraints { make in
            make.leading.equalTo(headerBar)
            make.centerY.equalTo(headerBar)
            make.height.equalTo(24)
        }
        
        swimYearsLabel.snp.makeConstraints { make in
            make.center.equalTo(swimYearsView)
            make.size.equalTo(swimYearsView).inset(4)
        }
        
        editProfile.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.center.equalTo(editProfile)
        }
        
        headerBar.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(Constant.deviceSize.width)
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
    }
}
#endif

