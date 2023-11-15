//
//  SignInViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit
import SnapKit
import Combine
import AuthenticationServices

final class SignInViewController: UIViewController, CombineCancellable {
    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: SignInViewModel

    //MARK: - Views
    private let titleLabel = ViewFactory.label("EverySwim")
        .font(.custom(.sfProBlack, size: 56))
        .textAlignemnt(.center)

    private let subtitleLabel = ViewFactory.label("기록하고 관리하기")
        .font(.custom(.sfProLight, size: 18))
        .foregroundColor(AppUIColor.secondaryLabel)
        .textAlignemnt(.center)
    
    private lazy var guestSignInButtonLabel = ViewFactory.label("비로그인으로 계속하기")
        .font(.custom(.sfProMedium, size: 20))
        .foregroundColor(AppUIColor.label)
        .textAlignemnt(.center)
        .cornerRadius(8)
    
    private lazy var guestSignInButton = UIView()
        .cornerRadius(8)
        .backgroundColor(AppUIColor.secondaryBackground)
        .shadow(alpha: 0.3, x: 0, y: 0, blur: 3, spread: 0, radius: 8)
        .subview(guestSignInButtonLabel)

    private lazy var appleSignInButton = makeAppleSignInButton()
    
    // MARK: Stack Views
    private lazy var titlesVStack = ViewFactory.vStack()
        .addSubviews([titleLabel, subtitleLabel])
    
    private lazy var signInButtonVStack = ViewFactory.vStack()
        .addSubviews([appleSignInButton, guestSignInButton])
        .alignment(.center)
        .distribution(.fillEqually)
        .spacing(20)

    
    // MARK: - Init & Lift Cycles
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        bindGuestSignInTapGesture()
    }

    private func configure() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(titlesVStack)
        view.addSubview(signInButtonVStack)
        
        titlesVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(100)
        }
        
        signInButtonVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(128)
        }
 
        guestSignInButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalTo(signInButtonVStack)
        }
        
        
        guestSignInButtonLabel.snp.makeConstraints { make in
            make.center.equalTo(guestSignInButton)
        }
        
        appleSignInButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalTo(signInButtonVStack)
        }
        
    }
    
    /// 로그인 없이 계속하기 탭 제스쳐
    private func bindGuestSignInTapGesture() {
        guestSignInButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Apple SignIn Button
    func makeAppleSignInButton() -> ASAuthorizationAppleIDButton {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self,
                                      action: #selector(appleSignInButtonAction),
                                      for: .touchUpInside)
        return authorizationButton
    }
    
    /// 애플 로그인 Request 구성
    @objc
    func appleSignInButtonAction() {
        let request = viewModel.requestAppleSignIn()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

// MARK: - Apple SignIn
extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    /// Apple Login Modal Sheet 불러오기
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    /// Apple Login Request
    func authorizationController(controller: ASAuthorizationController, 
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        Task(priority: .userInitiated) {
            do {
                try await viewModel.signInWithApple(authorization: authorization)
                self.dismiss(animated: true)
            } catch {
                print(error)
            }
        }
    }
    
    /// 애플 로그인 오류 처리
    func authorizationController(controller: ASAuthorizationController, 
                                 didCompleteWithError error: Error) {
        print("Apple SignIn Error \(error.localizedDescription)")
        let alertController = UIAlertController(title: "로그인 오류", message: "\(error.localizedDescription)", preferredStyle: .alert)
        
        self.present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.dismiss(animated: true)
            }
        }
    }
    
}

#if DEBUG
import SwiftUI

struct SignInViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SignInViewController(viewModel: .init())
        }
    }
}
#endif

