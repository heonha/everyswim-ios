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
    
    // 맵 설정
    func makeUIView(context: Context) -> NMFNaverMapView {
        let nmapView = NMFNaverMapView()
        nmapView.showZoomControls = false
        
        nmapView.showLocationButton = !isMiniMode
        nmapView.showScaleBar = !isMiniMode
        
        nmapView.mapView.zoomLevel = 17
        nmapView.mapView.mapType = .basic
        nmapView.mapView.touchDelegate = context.coordinator
        nmapView.mapView.positionMode = .normal
        setMarkers(mapView: nmapView.mapView)
        
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
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: self.viewModel)
    }
    
}

// MARK: - 부가설정

extension NaverMapView {
    
    // 마커
    private func setMarkers(mapView: NMFMapView) {
        let marker = NMFMarker()
        marker.captionText = "구로50플러스수영장"
        marker.position = NMGLatLng(lat: 37.488445, lng: 126.841984)
        marker.mapView = mapView
        marker.iconImage = NMF_MARKER_IMAGE_BLUE
        marker.touchHandler = { (_: NMFOverlay) -> Bool in
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)

            return true
        }
    }
    
}


class MapSceneViewModel: ObservableObject {
    
}

#if DEBUG
struct MapScene_Previews: PreviewProvider {
    static var previews: some View {
        NaverMapView(userLatitude: 37.488445, userLongitude: 126.841984)
    }
}
#endif
