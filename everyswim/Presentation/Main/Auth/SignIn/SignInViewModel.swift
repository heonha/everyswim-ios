//
//  SignInViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit
import Combine
import AuthenticationServices

class SignInViewModel: ObservableObject {
    
    private let appleSignService: AppleSignInHelper
    private let authManager = AuthManager.shared
    
    // MARK: - Init
    init(appleSignService: AppleSignInHelper = .init()) {
        self.appleSignService = appleSignService
    }
    
    // MARK: - SignIn with Apple
    /// 애플 로그인 Request 구성
    func requestAppleSignIn() -> ASAuthorizationAppleIDRequest {
        return appleSignService.createSignInRequest()
    }
    
    func signInWithApple(authorization: ASAuthorization) async throws {
        try await appleSignService.signIn(authorization: authorization)
    }

}
