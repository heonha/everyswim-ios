//
//  MainView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

enum MainTabs {
    case home
    case record
    case myinfo
}

struct MainView: View {
    
    @State var selectedTab: MainTabs = .home
    @StateObject var viewModel = MainViewModel.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            EventDatePickerContainer()
                .tabItem {
                    Label("기록", systemImage: "chart.bar.xaxis")
                }
                .tag(MainTabs.record)
            
            HomeRecordsView()
                .tabItem {
                    Label("대시보드", systemImage: "figure.pool.swim")
                }
                .tag(MainTabs.home)
            
            MyInfoView()
                .tabItem {
                    Label("내 정보", systemImage: "person.circle.fill")
                }
                .tag(MainTabs.myinfo)
            
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
