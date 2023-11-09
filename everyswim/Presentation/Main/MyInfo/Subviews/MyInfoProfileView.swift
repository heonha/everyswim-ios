//
//  MyInfoProfileView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit
import SnapKit

final class MyInfoProfileView: UIView {
    
    private lazy var profileImage = UIImageView()
        .setImage(.init(named: "Avatar"))
        .contentMode(.scaleAspectFit)
        .shadow(color: .black, alpha: 0.2, x: 0.3, y: 0.3, blur: 1, spread: 1, radius: 1)
        .cornerRadius(30)
    
    private lazy var profileTitle = ViewFactory
        .label("Heon Ha")
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(AppUIColor.label)
    
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
    
    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSuperViewHeight()
    }
    
}

extension MyInfoProfileView {
    
    private func configure() {
        
    }
    
    private func layout() {
        self.addSubview(profileView)

        // Profile View
        profileView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        profileEmail.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(24)
            make.horizontalEdges.equalTo(profileEmailBackground).inset(12)
        }
        
    }
    
    private func setSuperViewHeight() {
        let height = profileView.frame.height
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
}

#if DEBUG
import SwiftUI

struct MyInfoProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            MyInfoProfileView()
        }
    }
}
#endif

