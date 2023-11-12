//
//  SignInViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit
import AuthenticationServices


class SignInViewModel: ObservableObject {
    
    private let appleSignService: AppleSignInHelper
    private let authService = AuthManager.shared
    
    var isSignIn: Bool {
        get {
            return AuthManager.shared.isSignIn
        }
    }
    
    init(appleSignService: AppleSignInHelper = .init()) {
        self.appleSignService = appleSignService
    }
    
    /// 애플 로그인 Request 구성
    func requestAppleSignIn() -> ASAuthorizationAppleIDRequest {
        return appleSignService.createSignInRequest()
    }
    
    // MARK: Guest SignIn Button
    func autoSignIn(animated: Bool) {
        authService.signInForGuest()
    }
    
    func signInWithApple(authorization: ASAuthorization, completion: @escaping(Result<Void, Error>) -> Void) {
        appleSignService.signIn(authorization: authorization, completion: completion)
    }

}
