//
//  NaverMapView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/23/23.
//

import UIKit
import SnapKit
import NMapsMap

final class NaverMapView: BaseUIView, BaseUIViewProtocol {
    
    private var authDelegate: NMFAuthManagerDelegate?
    lazy var rootMapView = NMFNaverMapView(frame: contentView.frame)
    var markers = [NMFMarker]()

    // MARK: - Init
    init(currentLocation: CLLocationCoordinate2D) {
        super.init()
        updateCamera(currentLocation)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    // MARK: - Configure
    func configure() {
        configureNMapView()
    }

    public func authDelegate(target: NMFAuthManagerDelegate) {
        NMFAuthManager.shared().delegate = authDelegate
    }
    
    private func configureNMapView() {
        rootMapView.showLocationButton = true
        rootMapView.showScaleBar = false
    }
    
    // MARK: - Layout
    func layout() {
        layoutMapView()
    }
    
    private func layoutMapView() {
        contentView.addSubview(rootMapView)
        rootMapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    // MARK: - Marker
    /// `Map Marker` 단일 추가 메소드
    public func setMarkerOnMap(title: String, lat: CGFloat, lon: CGFloat) -> NMFMarker {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lon)
        marker.captionText = title
        print("DEBUG_MARKER: title - \(title), Position- \(marker.position)")
        
        let image = UIImage.init(named: "swim-maker")!
        let makerImage = NMFOverlayImage(image: image, reuseIdentifier: "swim-maker")
        marker.iconImage = makerImage
        marker.width = 40
        marker.height = 40
        
        marker.iconPerspectiveEnabled = true
        marker.isHideCollidedSymbols = true
        marker.isHideCollidedMarkers = true
        
        marker.iconTintColor = UIColor.blue
        return marker
    }
    
    /// 지도 마커 업데이트.
    public func placeMarker(locations: [MapMarkerModel]) {
        self.markers.removeAll()
        locations.forEach { place in
            if let lat = place.y.toDouble(),
               let lon = place.x.toDouble() {
                let marker = setMarkerOnMap(title: place.placeName, lat: lat, lon: lon)
                marker.mapView = rootMapView.mapView
                self.markers.append(marker)
            }
        }
    }
    
    // MARK: - Camera
    public func updateCamera(_ location: CLLocationCoordinate2D) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let mapView = self.rootMapView.mapView
            let naverMapLocation = NMGLatLng(lat: location.latitude, lng: location.longitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: naverMapLocation)
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
            mapView.positionMode = .normal
        }
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct NaverMapView_Previews: PreviewProvider {
    
    static let view = NaverMapView(currentLocation: TestLocationObject.coordinatorGuroGu)
    static let parentVC = PoolMapViewController(viewModel: parentVCViewModel)
    static let parentVCViewModel = PoolMapViewModel(locationManager: .init(),
                                                    regionSearchManager: .init())
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(height: 100)
        .frame(width: 393)
        .onAppear {
            view.authDelegate(target: parentVC)
        }
    }
}
#endif
