//
//  MainView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

enum MainTabs {
    case home
    case pool
    case myinfo
}

struct MainView: View {
    
    @State var selectedTab: MainTabs = .home
    @StateObject var viewModel = MainViewModel.shared
    
    var body: some View {
            TabView(selection: $selectedTab) {
                    
                HomeRecordsView()
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
