//
//  MyInfoButton.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

final class MyInfoButton: UIView {
    
    private var background = UIView()
        .backgroundColor(.white)
        .cornerRadius(12)
    
    private var symbol = UIImageView()
        .setSymbolImage(systemName: "person.circle", color: .secondaryLabel)
        
    
    private var label = ViewFactory.label("회원정보 변경")
        .font(.custom(.sfProMedium, size: 16))
        .foregroundColor(.label)

    private lazy var hstack = ViewFactory.hStack()
        .addSubviews([UIView.spacer(), symbol, label, UIView.spacer()])
        .alignment(.center)
        .distribution(.fill)
        .spacing(8)
    
    init() {
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
        self.addSubview(background)
        background.addSubview(hstack)
        
        background.snp.makeConstraints { make in
            make.height.equalTo(50)
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

#if DEBUG
import SwiftUI

struct MyInfoButton_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            MyInfoButton()
        }
        .frame(height: 100)
        .padding(.vertical)
        .background(.black)
    }
}
#endif

