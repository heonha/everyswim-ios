//
//  PoolsViewContainer.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI
import CoreLocation

struct PoolsMapViewContainer: View {
    
    
    @State private var text = ""
    @State private var locationManager = CLLocationManager()
    @FocusState private var searchFocused: Bool
    
    // Drag Guesture
    @State private var startingOffsetY: CGFloat = Constant.deviceSize.height * 0.50
    @State private var currentDragOffsetY: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    @State private var isLocationAuthed = false
    
    // Animation
    @State private var slidingAnimation: Animation = .spring(response: 0.5, dampingFraction: 1, blendDuration: 0.7)
    
    // pool list interection
    @State private var showDetail = false
    
    var body: some View {
        NavigationView {
            mainBody
        }
    }
    
}

// MARK: - Views
extension PoolsMapViewContainer {
    
    private var topInterectionView: some View {
        
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.init(uiColor: .red))
            .frame(height: 20)
        
    }
    
    var mainBody: some View {
        ZStack {
            Rectangle()
                .fill(Color.secondary)
            
//            naverMapView(
//                lat: locationManager.location?.coordinate.latitude ?? 0,
//                lon: locationManager.location?.coordinate.longitude ?? 0)
            
            naverMapView(lat: 37.488445, lon: 126.841984)

            
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
                .focused($searchFocused)
                .modifier(SearchBarModifier(fillColor: .clear))
                .background(.regularMaterial)
                .cornerRadius(8)
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .shadow(color: .black.opacity(0.20), radius: 2, x: 1, y: 1)
                .shadow(color: .black.opacity(0.10), radius: 2, x: -1, y: -1)
            Spacer()
        }
        .onSubmit {
            searchFocused.toggle()
        }
    }
    
    private var poolListView: some View {
        poolListContainerView
            .offset(y: startingOffsetY)
            .offset(y: currentDragOffsetY)
            .offset(y: endingOffsetY)
        
    }
}

// MARK: - Map View Handler
extension PoolsMapViewContainer {
    
    private func naverMapView(lat: CGFloat, lon: CGFloat) -> some View {
        NaverMapView(userLatitude: lat, userLongitude: lon)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                locationAuthorizedCheck(status: locationManager.authorizationStatus)
                print("lat: \(lat), lon: \(lon)")
            }
            .onTapGesture {
                searchFocused = false
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
    
    private var poolListContainerView: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(height: 25)
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.init(uiColor: .systemFill))
                    .frame(width: 36, height: 5)
                    .padding(.vertical)
                
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(slidingAnimation) {
                            currentDragOffsetY = value.translation.height
                        }
                    }
                    .onEnded { _ in
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
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    SwimmingPoolCell(pool: ._50plus)
                        .onTapGesture {
                            showDetail.toggle()
                        }
                    
                    SwimmingPoolCell(pool: .gochukdom)
                    
                    SwimmingPoolCell(pool: .guronam)
                }
            }
            .padding(.horizontal, 14)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.25), radius: 2, x: -1, y: -1)
        .fullScreenCover(isPresented: $showDetail) {
            PoolDetailView()
        }
    }
    
    
}

struct SwimmingPoolMapView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            PoolsMapViewContainer()
                .tabItem {
                    Label("수영장찾기", systemImage: "person")
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
        }
    }
}
