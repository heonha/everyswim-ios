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

    private let viewModel: PoolViewModel
    private lazy var mapView = NaverMapView(currentLocation: viewModel.targetCurrentLocation, parentVC: self)

    // MARK: - Init
    init(viewModel: PoolViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getLocation()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    // MARK: - Configure
    private func configure() {
        setNaviagationTitle(title: "수영장 찾기")
    }
    
    // MARK: - Layout
    private func layout() {
        layoutMapView()
    }
    
    private func layoutMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    private func bind() {
        bindUpdateMapMarker()
    }
    
    /// 유저 위치로 카메라 이동 (1회)
    private func bindUpdateCameraToGPSLocation() {
        viewModel.$targetCurrentLocation
            .receive(on: DispatchQueue.main)
            .filter { $0.latitude != CGFloat(0) && $0.longitude != CGFloat(0) }
            .prefix(1)
            .sink { [weak self] location in
                self?.mapView.updateCamera(location)
            }
            .store(in: &cancellables)
    }
    
    /// 수영장 ViewModel이 변경 될 때마다 업데이트
    private func bindUpdateMapMarker() {
        viewModel.places
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] pools in
                self?.mapView.placeMarker(locations: pools)
            }
            .store(in: &cancellables)
    }

    // MARK: - ETC Methods
    /// GPS Location 정보를 가져옵니다.
    private func getLocation() {
        viewModel.getCurrentLocation()
    }
    
    /// 마커를 셋업합니다.
    public func placeMarker(from locations: [MapPlace]) {
        mapView.placeMarker(locations: locations)
    }
    
    /// 카메라 위치를 업데이트합니다.
    public func updateCamera(_ location: CLLocationCoordinate2D) {
        mapView.updateCamera(location)
    }
    
    /// 마커를 수동으로 선택합니다.
    public func selectMarker(target place: MapPlace) {
        mapView.showPlaceInfoView(place: place)
    }
    
}

// MARK: - MapView Auth Delegate
extension MapViewController: NMFAuthManagerDelegate, NMFMapViewTouchDelegate {
    
    func authorized(_ state: NMFAuthState, error: Error?) {
        if let error = error {
            print("AuthError: \(error.localizedDescription)")
            return
        }
        print("STATE: \(state)")
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("맵터치")
        self.mapView.hidePlaceInfoView()
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct MapViewController_Previews: PreviewProvider {
    
    static let viewController = MapViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager.shared
    static let viewModel = PoolViewModel(locationManager: locationManager, regionSearchManager: .init())
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
