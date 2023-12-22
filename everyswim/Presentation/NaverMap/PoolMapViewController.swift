//
//  PoolMapViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/30/23.
//

import UIKit
import SnapKit
import NMapsMap
import Combine

final class PoolMapViewController: BaseViewController {
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: PoolMapViewModel
    
    private lazy var mapView = NMFNaverMapView(frame: view.frame)
    private var markers = [NMFMarker]()

    init(viewModel: PoolMapViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindCurrentLocation()
        bindSearchPool()
    }

    // MARK: - Configure
    private func configure() {
        configureNMapAuth()
        configureNMapView()
    }
    
    private func configureNMapAuth() {
        NMFAuthManager.shared().delegate = self
    }
    
    private func configureNMapView() {
        mapView.showLocationButton = true
        mapView.showScaleBar = false
    }
    
    // MARK: - Layout
    private func layout() {
        layoutMapView()
    }
    
    private func layoutMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: - Helpers
    private func getLocation() {
        viewModel.getCurrentLocation()
    }
    
    private func bindCurrentLocation() {
        viewModel.$currentLoction
            .receive(on: DispatchQueue.main)
            .filter { $0.latitude != CGFloat(0) && $0.longitude != CGFloat(0) }
            .sink { [weak self] location in
                self?.moveToCurrentLocation(location)
            }
            .store(in: &cancellables)
    }
    
    private func moveToCurrentLocation(_ location: CLLocationCoordinate2D) {
        let naverMapLocation = NMGLatLng(lat: location.latitude, lng: location.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: naverMapLocation)
        mapView.mapView.moveCamera(cameraUpdate)
        cameraUpdate.animation = .easeIn
        self.mapView.mapView.positionMode = .normal
    }
    
    /// 지도에 마커 추가하기.
    public func placeMarker(locations: [KakaoPlace]) {
        markers.removeAll()
        locations.forEach { place in
            if let lat = place.y.toDouble(),
               let lon = place.x.toDouble() {
                let marker = setMarkerOnMap(title: place.placeName, lat: lat, lon: lon)
                marker.mapView = mapView.mapView
                self.markers.append(marker)
            }
        }
    }
    
    /// 수영장 ViewModel이 변경 될 때마다 업데이트
    private func bindSearchPool() {
        viewModel.$pools
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] pools in
                guard let self = self else { return }
                placeMarker(locations: pools)
            }
            .store(in: &cancellables)
    }
    
    /// `Map Marker` 추가 메소드
    func setMarkerOnMap(title: String, lat: CGFloat, lon: CGFloat) -> NMFMarker {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lon)
        marker.captionText = title
        print("DEBUG_MARKER: title - \(title), Position- \(marker.position)")
        
        let image = UIImage.init(named: "swim-maker")!
        let makerImage = NMFOverlayImage(image: image, reuseIdentifier: "swim-maker")
        marker.iconImage = makerImage
        marker.width = 40
        marker.height = 50
        
        marker.iconPerspectiveEnabled = true
        marker.isHideCollidedSymbols = true
        marker.isHideCollidedMarkers = true
        
        marker.iconTintColor = UIColor.blue
        return marker
    }
    
}

// MARK: - MapView Auth Delegate
extension PoolMapViewController: NMFAuthManagerDelegate {
    
    func authorized(_ state: NMFAuthState, error: Error?) {
        if let error = error {
            print("AuthError: \(error.localizedDescription)")
            return
        }
        print("STATE: \(state)")
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MapViewController_Previews: PreviewProvider {
    
    static let viewController = PoolMapViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager()
    static let viewModel = PoolMapViewModel(locationManager: locationManager, regionSearchManager: .init())
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
