//
//  MainView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct MainView: View {
    
    enum MainTabs {
        case home
        case pool
        case myinfo
    }
    
    @State var selectedTab: MainTabs = .home
    @StateObject var viewModel = MainViewModel.shared
    
    var body: some View {
            TabView(selection: $selectedTab) {
                    
                HomeView()
                    .tabItem {
                        Label("수영", systemImage: "figure.pool.swim")
                    }
                
                PoolsMapViewContainer()
                    .tabItem {
                        Label("수영장찾기", systemImage: "map")
                    }
                
                MyInfoView()
                    .tabItem {
                        Label("내 정보", systemImage: "person.circle.fill")
                    }
            }
            .onAppear {
//                UITabBar.appearance().backgroundColor = .clear
                UITabBar.appearance().isTranslucent = true
            }
            .environmentObject(viewModel)

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


struct SwimmingData {
    
    let duration: String
    let startTime: String
    let endTime: String
    let distance: Double?
    let activeKcal: Double?
    let restKcal: Double?
    let stroke: Double?
}
