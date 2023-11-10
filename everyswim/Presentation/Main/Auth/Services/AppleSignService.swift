//
//  AppleSignService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

final class AppleSignService {
    
    // MARK: Constant
    private struct Constant {
        static let appleUserIdentifierKey = "appleUserIdentifierKey"
    }
    
    // MARK: Services
    private let fbCredentialService: FBCredentialService
    private let keychainService: KeyChainService

    // Nonce
    fileprivate var currentNonce: String?
    
    // MARK: - Init
    init(currentNonce: String? = nil, fbCredentialService: FBCredentialService = .init(), keychainService: KeyChainService = .init()) {
        self.fbCredentialService = fbCredentialService
        self.keychainService = keychainService
        self.currentNonce = currentNonce
    }
    
    
    func createSignInRequest() -> ASAuthorizationAppleIDRequest {
        let nonce = fbCredentialService.randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = fbCredentialService.sha256(nonce)
        
        return request
    }
    
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
            
            fbCredentialService.firebaseLogin(with: credential) { result in
                completion(result)
            }
            
        } else {
            completion(.failure(SignInError.failToFetchAppleIDCredential))
        }
    }

}
