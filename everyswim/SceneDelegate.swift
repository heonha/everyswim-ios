//
//  SceneDelegate.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {

    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white

        let authService = AuthService.shared

        if authService.isSignIn {
            let mainVC = MainTabBarController(authService: authService)
            window?.rootViewController = mainVC
            window?.makeKeyAndVisible()
        } else {
            // 비로그인
            let signInViewModel = SignInViewModel()
            let mainVC = SignInViewController(viewModel: signInViewModel, authService: authService)
            window?.rootViewController = mainVC
            window?.makeKeyAndVisible()
        }
        
        window?.makeKeyAndVisible()
    }
    
}
