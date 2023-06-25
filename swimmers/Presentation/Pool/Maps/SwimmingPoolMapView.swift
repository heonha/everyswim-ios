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

    var body: some View {
        ZStack {
            VStack {
                Group {
                    TextField("수영장 검색", text: $text)
                        .modifier(SearchBarModifier())
                }
                .frame(height: 50)
                
                NaverMapView(userLatitude: locationManager.location?.coordinate.latitude ?? 0, userLongitude: locationManager.location?.coordinate.longitude ?? 0)
                    .onAppear {
                        locationManager.requestWhenInUseAuthorization()
                        locationManager.startUpdatingLocation()
                        print("userLatitude: \(locationManager.location?.coordinate.latitude), userLongitude: \(locationManager.location?.coordinate.longitude)")
                    }
            }
            
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
