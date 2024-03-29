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
        window?.backgroundColor = UIColor.systemBackground
        
        // let mainVC = UIHostingController(rootView: MainView())
        // window?.rootViewController = mainVC
        // window?.makeKeyAndVisible()

        if self.isTestMode {
            let viewModel = SetProfileViewModel()
            let testVC = SetProfileViewController(viewModel: viewModel, type: .signUp)
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
