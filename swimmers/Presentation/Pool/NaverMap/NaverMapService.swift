//
//  NaverMapService.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/26.
//
import SwiftUI
import MapKit
import NMapsMap
import Combine

struct NaverMapView: UIViewRepresentable {
    @ObservedObject var viewModel = MapSceneViewModel()
    @State var userLatitude: Double
    @State var userLongitude: Double
    var isMiniMode = true
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let nmapView = NMFNaverMapView()
        nmapView.showZoomControls = false
        
        nmapView.showLocationButton = !isMiniMode
        nmapView.showScaleBar = !isMiniMode
        
        nmapView.mapView.zoomLevel = 17
        nmapView.mapView.mapType = .basic
        nmapView.mapView.touchDelegate = context.coordinator
        nmapView.mapView.positionMode = .normal
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        nmapView.mapView.moveCamera(cameraUpdate)
        
        return nmapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
        
        @ObservedObject var viewModel: MapSceneViewModel
        
        var cancellable = Set<AnyCancellable>()
        
        init(viewModel: MapSceneViewModel) {
            self.viewModel = viewModel
        }
        
        // 지도 탭
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            print("\(latlng.lat), \(latlng.lng)")
        }
        
        // 특정 탭
        func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
            if symbol.caption == "서울특별시청" {
                print("서울시청 탭")
                return true

            } else {
                print("symbol 탭")
                return false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: self.viewModel)
    }
}

class MapSceneViewModel: ObservableObject {
    
}

#if DEBUG
struct MapScene_Previews: PreviewProvider {
    static var previews: some View {
        NaverMapView(userLatitude: 0, userLongitude: 0)
    }
}
#endif
