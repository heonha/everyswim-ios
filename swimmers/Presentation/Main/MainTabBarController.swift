//
//  MainTabBarController.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {
    
    private let eventVC = UIHostingController(rootView: EventDatePickerContainer())
    private let homeVC = DashboardViewController()
    private let myInfoVC = UIHostingController(rootView: MyInfoViewSwiftUI())
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let eventNavigation = UINavigationController(rootViewController: eventVC)
        eventNavigation.isNavigationBarHidden = true
        eventNavigation.tabBarItem = .init(title: "수영", image: eventSymbol, tag: 0)

        let homeNavigation = UINavigationController(rootViewController: homeVC)
        homeNavigation.isNavigationBarHidden = true
        homeNavigation.tabBarItem = .init(title: "대시보드", image: homeSymbol, tag: 1)

        let myInfoNavigation = UINavigationController(rootViewController: myInfoVC)
        myInfoNavigation.isNavigationBarHidden = true
        myInfoNavigation.tabBarItem = .init(title: "내 정보", image: myInfoSymbol, tag: 2)
        
        self.viewControllers = [eventNavigation, homeNavigation, myInfoNavigation]
    }
    
}

#Preview {
    MainTabBarController()
}
