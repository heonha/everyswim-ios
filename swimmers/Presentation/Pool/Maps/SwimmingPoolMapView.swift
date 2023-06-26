//
//  SwimmingPoolMapView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI
import CoreLocation

struct SwimmingPoolMapView: View {
    
    @State private var text = ""
    @State private var locationManager = CLLocationManager()
    @State var uiTabarController: UITabBarController?

    var body: some View {
        ZStack {
            
            NaverMapView(userLatitude: locationManager.location?.coordinate.latitude ?? 0, userLongitude: locationManager.location?.coordinate.longitude ?? 0)
                .onAppear {
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.startUpdatingLocation()
                    print("userLatitude: \(locationManager.location?.coordinate.latitude), userLongitude: \(locationManager.location?.coordinate.longitude)")
                }

            VStack {
                    TextField("수영장 검색", text: $text)
                        .modifier(SearchBarModifier())
                        .cornerRadius(8)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                        .shadow(color: .black.opacity(0.20), radius: 2, x: 1, y: 1)
                        .shadow(color: .black.opacity(0.10), radius: 2, x: -1, y: -1)
                Spacer()
            }
            
        }
        .onAppear {
            uiTabarController?.tabBar.isHidden = true
        }
        .onDisappear {
            uiTabarController?.tabBar.isHidden = false
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("주변 수영장 찾기")
                    .font(.custom(.sfProBold, size: 17))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct SwimmingPoolMapView_Previews: PreviewProvider {
    static var previews: some View {
        SwimmingPoolMapView()
    }
}
