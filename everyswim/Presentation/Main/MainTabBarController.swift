//
//  MainTabBarController.swift
//  swimmersd
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {
    
    private let authService: AuthManager
    private lazy var recordView = ActivityViewController()
    private lazy var dashboardView = DashboardViewController()
    private lazy var myInfoView = MyInfoController()
    private lazy var calendarView = DatePickerController()

    init(authService: AuthManager) {
        self.authService = authService
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
        let homeSymbol = UIImage(systemName: "list.bullet.rectangle")
        let eventSymbol = UIImage(systemName: "figure.pool.swim")
        let calendarSymbol = UIImage(systemName: "calendar")
        let myInfoSymbol = UIImage(systemName: "person.circle.fill")
        
        let dashboardNC = BaseNavigationController(rootViewController: dashboardView)
        dashboardNC.isNavigationBarHidden = true
        dashboardNC.tabBarItem = .init(title: "대시보드", image: homeSymbol, tag: 0)

        let recordNC = BaseNavigationController(rootViewController: recordView)
        recordNC.isNavigationBarHidden = true
        recordNC.tabBarItem = .init(title: "기록", image: eventSymbol, tag: 1)

        let calendarNC = BaseNavigationController(rootViewController: calendarView)
        calendarNC.isNavigationBarHidden = true
        calendarNC.tabBarItem = .init(title: "캘린더", image: calendarSymbol, tag: 2)

        let myInfoNC = BaseNavigationController(rootViewController: myInfoView)
        myInfoNC.isNavigationBarHidden = true
        myInfoNC.tabBarItem = .init(title: "내 정보", image: myInfoSymbol, tag: 3)
        
        self.viewControllers = [dashboardNC, recordNC, calendarNC, myInfoNC]
        self.selectedIndex = 0
    }
    
}

#Preview {
    MainTabBarController(authService: AuthManager.shared)
}
