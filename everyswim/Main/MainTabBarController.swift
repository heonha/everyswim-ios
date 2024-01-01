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
    
    private let dashboardViewModel = DashboardViewModel()
    private lazy var dashboardView = DashboardViewController(viewModel: dashboardViewModel)
    
    private let myInfoViewModel = MyInfoViewModel()
    private lazy var myInfoView = MyInfoViewController(viewModel: myInfoViewModel)
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
        let homeSymbol = AppImage.listbulletRectangle.getImage()
        let eventSymbol = AppImage.swim.getImage()
        let calendarSymbol = AppImage.calendar.getImage()
        let myInfoSymbol = AppImage.personCircleFill.getImage()
        
        let dashboardNC = RootNavigationViewController(rootViewController: dashboardView)
        dashboardNC.isNavigationBarHidden = true
        dashboardNC.tabBarItem = .init(title: "대시보드", image: homeSymbol, tag: 0)

        let recordNC = RootNavigationViewController(rootViewController: recordView)
        recordNC.isNavigationBarHidden = true
        recordNC.tabBarItem = .init(title: "기록", image: eventSymbol, tag: 1)

        let calendarNC = RootNavigationViewController(rootViewController: calendarView)
        calendarNC.isNavigationBarHidden = true
        calendarNC.tabBarItem = .init(title: "캘린더", image: calendarSymbol, tag: 2)

        let myInfoNC = RootNavigationViewController(rootViewController: myInfoView)
        myInfoNC.isNavigationBarHidden = true
        myInfoNC.tabBarItem = .init(title: "내 정보", image: myInfoSymbol, tag: 3)
        
        self.viewControllers = [dashboardNC, recordNC, calendarNC, myInfoNC]
        self.selectedIndex = 0
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MainTabBarController_Previews: PreviewProvider {
    
    static let viewController = MainTabBarController(authService: authService)
    static let authService = AuthManager.shared
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
