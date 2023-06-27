//
//  PoolsViewContainer.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI
import CoreLocation

struct PoolsViewContainer: View {
    
    @State private var text = ""
    @State private var locationManager = CLLocationManager()
    
    // Drag Guesture
    @State private var startingOffsetY: CGFloat = Constant.deviceSize.height * 0.75
    @State private var currentDragOffsetY: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    @State private var isLocationAuthed = false
    
    // Animation
    @State private var slidingAnimation: Animation = Animation.spring(response: 0.5,
                                                                      dampingFraction: 1,
                                                                      blendDuration: 0.7)
    
    var body: some View {
        NavigationView {
            mainBody
        }
    }
    
}

// MARK: - Views
extension PoolsViewContainer {
    
    var mainBody: some View {
        ZStack {
            Rectangle()
                .fill(Color.secondary)
            
            naverMapView(lat: locationManager.location?.coordinate.latitude ?? 0,
                         lon: locationManager.location?.coordinate.longitude ?? 0)
            
            searchField($text)
            
            poolListView
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteBarItem()
            }
        }
        .navigationTitle("주변 수영장 찾기")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func favoriteBarItem() -> some View {
        Button {
            print("My Favorite Pool View")
        } label: {
            Image(systemName: "heart.fill")
                .foregroundColor(Color.init(hex: "ED4444"))
        }
    }
    
    private func searchField(_ text: Binding<String>) -> some View {
        VStack {
            TextField("\(currentDragOffsetY)", text: $text)
                .modifier(SearchBarModifier())
                .cornerRadius(8)
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .shadow(color: .black.opacity(0.20), radius: 2, x: 1, y: 1)
                .shadow(color: .black.opacity(0.10), radius: 2, x: -1, y: -1)
            Spacer()
        }
    }
    
    private var poolListView: some View {
        PoolListView()
            .cornerRadius(16)
            .offset(y: startingOffsetY)
            .offset(y: currentDragOffsetY)
            .offset(y: endingOffsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(slidingAnimation) {
                            currentDragOffsetY = value.translation.height
                        }
                    }
                    .onEnded { value in
                        withAnimation(slidingAnimation) {
                            if currentDragOffsetY < -150 {
                                let topPadding: CGFloat = 60
                                endingOffsetY = -startingOffsetY + topPadding
                                currentDragOffsetY = 0
                                
                            } else if endingOffsetY <= 60 && currentDragOffsetY > 150 {
                                endingOffsetY = 0
                                currentDragOffsetY = 0
                                
                            } else {
                                currentDragOffsetY = 0
                            }
                        }
                    }
            )
    }
}

// MARK: - Map View Handler
extension PoolsViewContainer {
    
    private func naverMapView(lat: CGFloat, lon: CGFloat) -> some View {
        NaverMapView(userLatitude: lat, userLongitude: lon)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                locationAuthorizedCheck(status: locationManager.authorizationStatus)
                print("lat: \(lat), lon: \(lon)")
            }
    }
    
    private func locationAuthorizedCheck(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthed = true
            print("✅ 위치권한 승인 됨")
        default:
            isLocationAuthed = false
            print("⚠️ 위치권한 승인 필요")
        }
    }
    
    
}

struct SwimmingPoolMapView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            PoolsViewContainer()
                .tabItem {
                    Label("수영장찾기", systemImage: "person")
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
        }
    }
}
