//
//  MapViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/30/23.
//

import UIKit
import SnapKit
import NMapsMap
import Combine

final class MapViewController: BaseViewController {
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: MapViewModel
    
    private lazy var mapView = NMFNaverMapView(frame: view.frame)
    
    init(viewModel: MapViewModel) {
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
    }

    private func configure() {
        NMFAuthManager.shared().delegate = self
        mapView.showLocationButton = true
        mapView.showScaleBar = false
    }
    
    private func layout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
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
    
}

extension MapViewController: NMFAuthManagerDelegate {
    
    func placeMarker(title: String, _ lat: CGFloat, _ lng: CGFloat) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.captionText = "구로 50플러스 수영장"
        marker.mapView = mapView.mapView
        
        let image = UIImage.init(named: "swim-maker")!
        let makerImage = NMFOverlayImage(image: image, reuseIdentifier: "swim-maker")
        marker.iconImage = makerImage
        marker.width = 40
        marker.height = 50
        
        marker.iconPerspectiveEnabled = true
        marker.isHideCollidedSymbols = true
        marker.isHideCollidedMarkers = true
        
        marker.iconTintColor = UIColor.blue
    }
    
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
    
    static let viewController = MapViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager()
    static let viewModel = MapViewModel(locationManager: locationManager)
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
