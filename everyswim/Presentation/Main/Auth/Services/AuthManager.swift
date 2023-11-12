//
//  AuthManager.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit
import FirebaseAuth

final class AuthManager {
    
    private struct Constant {
        static let isSignInKey = "isSignInKey"
    }
    
    private let appleSignService: AppleSignInHelper
    private let fbCredentialService: FirebaseAuthService
    
    static let shared = AuthManager()
    
    var isSignIn: Bool = false
    private var user: UserProfile?
    
    private init(apple: AppleSignInHelper = .init(), fbCredentialService: FirebaseAuthService = .init()) {
        self.appleSignService = apple
        self.fbCredentialService = fbCredentialService
    }
    
    /// 로그인 전 기본값
    func signInForGuest() {
        self.isSignIn = true
        saveSignInState()
        // TODO: Firebase Guest Login 추가
    }
        
    func signIn(with user: UserProfile) {
        print(user)
        self.user = user
    }
    
    func signOut() {
        self.isSignIn = false
        saveSignInState()
    }
    
    func saveSignInState() {
        UserDefaults.standard.setValue(isSignIn, forKey: Constant.isSignInKey)
    }
    
    /// Firebase에서 인증된 Current User 가져오기
    func getAuthenticatedUser() throws -> UserProfile {
        do {
            let user = try fbCredentialService.getAuthenticatedUser()
            let userProfile = UserProfile(uid: user.uid, name: user.displayName, email: user.email, providerId: user.providerID, profileImageUrl: "https://media.idownloadblog.com/wp-content/uploads/2018/07/Tim-Cook-memoji.jpg")
            self.user = userProfile
            return userProfile
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getEmail() -> String? {
        return self.user?.email
    }
        
    
}
