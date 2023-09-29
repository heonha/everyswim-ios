//
//  MainTabBarController.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {
    
    private lazy var eventVC = DatePickerController()
    private lazy var homeVC = DashboardViewController()
    private lazy var myInfoVC = MyInfoController()
    
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
        let eventSymbol = UIImage(systemName: "chart.bar.xaxis")
        let homeSymbol = UIImage(systemName: "figure.pool.swim")
        let myInfoSymbol = UIImage(systemName: "person.circle.fill")
        
        let eventNavigation = BaseNavigationController(rootViewController: eventVC)
        eventNavigation.isNavigationBarHidden = true
        eventNavigation.tabBarItem = .init(title: "수영", image: eventSymbol, tag: 0)

        let homeNavigation = BaseNavigationController(rootViewController: homeVC)
        homeNavigation.isNavigationBarHidden = true
        homeNavigation.tabBarItem = .init(title: "대시보드", image: homeSymbol, tag: 1)

        let myInfoNavigation = BaseNavigationController(rootViewController: myInfoVC)
        myInfoNavigation.isNavigationBarHidden = true
        myInfoNavigation.tabBarItem = .init(title: "내 정보", image: myInfoSymbol, tag: 2)
        
        self.viewControllers = [eventNavigation, homeNavigation, myInfoNavigation]
    }
    
}

#Preview {
    MainTabBarController()
}
