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
    var isTestMode = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white

        if self.isTestMode {
            let testVC = SetProfileViewController()
            window?.rootViewController = testVC
            window?.makeKeyAndVisible()
        } else {
            let authService = AuthManager.shared
            let mainVC = MainTabBarController(authService: authService)
            window?.rootViewController = mainVC
            window?.makeKeyAndVisible()
        }
    }
    
}
