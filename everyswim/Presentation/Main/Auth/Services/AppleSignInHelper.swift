//
//  AppleSignInHelper.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

protocol SignInHelpers {
    var fbCredentialService: String { get }
}



final class AppleSignInHelper {
    
    // MARK: Constant
    private struct Constant {
        static let appleUserIdentifierKey = "appleUserIdentifierKey"
    }
    
    // MARK: Services
    private let fbCredentialService: FirebaseAuthService
    private let keychainService: KeyChainService

    // Nonce
    fileprivate var currentNonce: String?
    
    // MARK: - Init
    init(currentNonce: String? = nil, fbCredentialService: FirebaseAuthService = .init(), keychainService: KeyChainService = .init()) {
        self.fbCredentialService = fbCredentialService
        self.keychainService = keychainService
        self.currentNonce = currentNonce
    }
    
    // MARK: SignIn Request
    
    /// Apple SignIn Button을 통한 `로그인 Request 생성`
    func createSignInRequest() -> ASAuthorizationAppleIDRequest {
        let nonce = fbCredentialService.randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = fbCredentialService.sha256(nonce)
        
        return request
    }
    
    /// Apple Server에서 받은 Token을 통한 로그인 작업
    func signIn(authorization: ASAuthorization, completion: @escaping(Result<Void, Error>) -> Void) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                completion(.failure(SignInError.invalidNounce))
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                completion(.failure(SignInError.failFetchToken))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion(.failure(SignInError.failTokenPasing(message: appleIDToken.debugDescription)))
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            fbCredentialService.firebaseSignIn(with: credential) { result in
                completion(result)
            }
            
        } else {
            completion(.failure(SignInError.failToFetchAppleIDCredential))
        }
    }
    
    /// 계정이 있는 사용자의 인증, 세션 유지(최대 1달)
    func currentUserSignIn(authorization: ASAuthorization, completion: @escaping(Result<Void, Error>) -> Void) {

    }

}
