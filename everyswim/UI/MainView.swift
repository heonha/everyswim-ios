//
//  MainView.swift
//  everyswim
//
//  Created by HeonJin Ha on 3/16/24.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(0)
        }
    }
}

#Preview {
    MainView()
}
