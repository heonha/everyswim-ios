//
//  MyInfoButton.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

final class MyInfoButton: UIView {
    
    private let type: MyInfoButtonType
    
    private var background = UIView()
        .backgroundColor(.white)
        .cornerRadius(12)
    
    private lazy var symbol = UIImageView()
        .setSymbolImage(systemName: type.getUIData().symbolName, 
                        color: .secondaryLabel)
        
    private lazy var label = ViewFactory
        .label(type.getUIData().title)
        .font(.custom(.sfProMedium, size: 16))
        .foregroundColor(AppUIColor.label)

    private lazy var hstack = ViewFactory.hStack()
        .addSubviews([UIView.spacer(), symbol, label, UIView.spacer()])
        .alignment(.center)
        .distribution(.fill)
        .spacing(8)
    
    init(_ type: MyInfoButtonType) {
        self.type = type
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.addSubview(background)
        background.addSubview(hstack)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        background.snp.makeConstraints { make in
            make.height.equalTo(self)
            make.horizontalEdges.equalTo(self)
        }
        
        hstack.snp.makeConstraints { make in
            make.centerY.equalTo(background)
            make.horizontalEdges.equalTo(background).inset(4)
        }
        
        symbol.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
}

extension MyInfoButton {
    
    func getType() -> MyInfoButtonType {
        return self.type
    }
    
    func getSection() -> MyInfoSection {
        switch self.type {
        case .changeUserInfo, .editChallange, .setupAlert, .syncHealth, .searchForPool:
            return MyInfoSection.first
        case .shareApp, .sendContact, .questions:
            return MyInfoSection.second
        case .logout, .deleteAccount:
            return MyInfoSection.third
        }
    }
    
}


#if DEBUG
import SwiftUI

struct MyInfoButton_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            MyInfoButton(.changeUserInfo)
        }
        .frame(maxWidth: .infinity, idealHeight: 60)
        .padding(.vertical)
    }
}
#endif

