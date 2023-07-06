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


struct SwimmingData: Identifiable {
    let id = UUID()
    let duration: TimeInterval
    let startDate: Date
    let endDate: Date
    let distance: Double?
    let activeKcal: Double?
    let restKcal: Double?
    let stroke: Double?
    
    func getDuration() -> String {
        return HKCalculator.duration(duration)
    }
    
    func getWorkoutTime() -> String {
        HKCalculator.dateHandeler(from: startDate, to: endDate)
    }
}


struct SwimCellData: Identifiable {
    let id = UUID()
    let title: String
    let distance: String
    let pace: String
    let duration: String
}
