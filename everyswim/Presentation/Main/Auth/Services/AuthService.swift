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
    
    private init(apple: AppleSignService = .init()) {
        self.appleSignService = apple
    }
    
    /// 로그인 전 기본값
    func signInForGuest() {
        self.isSignIn = true
        saveSignInState()
        switchMainView()
        // TODO: Firebase Guest Login 추가
    }
    
    func signOut() {
        self.isSignIn = false
        saveSignInState()
        switchSignInView()
    }
    
    /// 메인 화면으로 이동 (로그인 상태)
    private func switchMainView() {
        let mainVC = MainTabBarController(authService: self)
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = mainVC
    }
    
    /// 로그인 뷰로 이동 (비로그인 상태)
    private func switchSignInView() {
        let signVC = SignInViewController(viewModel: .init(), authService: self)
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = signVC
    }
    
    
    
    func saveSignInState() {
        UserDefaults.standard.setValue(isSignIn, forKey: Constant.isSignInKey)
    }
    
    private func signInSwitch() {
        
    }
        
    
}
