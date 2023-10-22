//
//  MainTabBarController.swift
//  swimmersd
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {
    
    private lazy var recordView = ActivityViewController()
    private lazy var dashboardView = DashboardViewController()
    private lazy var myInfoView = MyInfoController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has  been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupEachTabViews()
    }
    
}

extension MainTabBarController {

    private func setupTabBar() {
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = AppUIColor.primary
    }
    
    private func setupEachTabViews() {
        let eventSymbol = UIImage(systemName: "figure.pool.swim")
        let homeSymbol = UIImage(systemName: "list.bullet.clipboard")
        let myInfoSymbol = UIImage(systemName: "person.circle.fill")
        
        let recordNC = BaseNavigationController(rootViewController: recordView)
        recordNC.isNavigationBarHidden = true
        recordNC.tabBarItem = .init(title: "기록", image: eventSymbol, tag: 0)

        let dashboardNC = BaseNavigationController(rootViewController: dashboardView)
        dashboardNC.isNavigationBarHidden = true
        dashboardNC.tabBarItem = .init(title: "대시보드", image: homeSymbol, tag: 1)

        let myInfoNC = BaseNavigationController(rootViewController: myInfoView)
        myInfoNC.isNavigationBarHidden = true
        myInfoNC.tabBarItem = .init(title: "내 정보", image: myInfoSymbol, tag: 2)
        
        self.viewControllers = [recordNC, dashboardNC, myInfoNC]
        self.selectedIndex = 1
    }
    
}

#Preview {
    MainTabBarController()
}
