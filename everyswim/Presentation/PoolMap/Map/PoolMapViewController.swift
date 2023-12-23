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
    private lazy var mapView = NaverMapView(currentLocation: viewModel.targetCurrentLocation)

    // MARK: - Init
    init(viewModel: PoolMapViewModel) {
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
        bindUpdateCameraToGPSLocation()
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
        viewModel.$places
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] pools in
                self?.mapView.placeMarker(locations: pools)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - ETC Methods
    private func getLocation() {
        viewModel.getCurrentLocation()
    }
    
    public func placeMarker(from locations: [MapMarkerModel]) {
        mapView.placeMarker(locations: locations)
    }
    
    public func updateCamera(_ location: CLLocationCoordinate2D) {
        mapView.updateCamera(location)
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
