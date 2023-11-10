//
//  AuthService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit

final class AuthService {
    
    private struct Constant {
        static let isSignInKey = "isSignInKey"
    }
        
    private let appleSignService: AppleSignService
    
    static let shared = AuthService()
    
    var isSignIn: Bool = false
    private var user: UserProfile?
    
    private init(apple: AppleSignService = .init()) {
        self.appleSignService = apple
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
    
    private func signInSwitch() {
        
    }
    
    func getEmail() -> String? {
        return self.user?.email
    }
        
    
}
