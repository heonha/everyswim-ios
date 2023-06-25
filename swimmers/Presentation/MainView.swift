//
//  MainView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct MainView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Label("수영", systemImage: "figure.pool.swim")
                    }
                
                SearchPoolView()
                    .tag(1)
                    .tabItem {
                        Label("수영장찾기", systemImage: "map")
                    }
                
                MyInfoView()
                    .tag(2)
                    .tabItem {
                        Label("내 정보", systemImage: "person.circle.fill")
                    }
            }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
