//
//  MyInfoProfileView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//

import UIKit
import SnapKit
import Combine

protocol TargetSendable {
    var parentViewController: UIViewController? { get set }
}

final class MyInfoProfileView: UIView, CombineCancellable, TargetSendable {
    
    var parentViewController: UIViewController?
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var profileImage = UIImageView()
        .setImage(.init(named: "user")?.withTintColor(.white))
        .contentMode(.scaleAspectFit)
        .backgroundColor(AppUIColor.secondaryBlue)
        .shadow(color: .black, alpha: 0.2, x: 0.3, y: 0.3, blur: 1, spread: 1, radius: 1)
        .cornerRadius(30)
    
    private lazy var profileTitle = ViewFactory
        .label("개발하는 물개")
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(AppUIColor.label)
    
    private lazy var profileEmailBackground = ViewFactory.hStack()
        .addSubviews([UIView.spacer(),
                      profileEmail,
                      UIView.spacer()])
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .cornerRadius(8)
        .shadow()

    private lazy var profileEmail = ViewFactory
        .label("로그인하기")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.secondaryLabel)
    
    private lazy var profileView = ViewFactory
        .vStack(subviews: [profileImage, profileTitle, profileEmailBackground])
        .spacing(8)
        .distribution(.fill)
        .alignment(.center)
    
    init(parentVC: UIViewController) {
        self.parentViewController = parentVC
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
        observe()
    }
    
}

extension MyInfoProfileView {
    
    private func configure() {
        
    }
    
    private func observe() {
        self.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let signInVC = SignInViewController(viewModel: .init())
                signInVC.modalPresentationStyle = .fullScreen
                self.parentViewController?.present(signInVC, animated: true)
            }
            .store(in: &cancellables)
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
            make.height.equalTo(24)
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
            MyInfoProfileView(parentVC: .init())
        }
        .frame(height: 150)
    }
}
#endif

