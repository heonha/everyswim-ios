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
    
    private weak var parentVC: MapViewController?
    lazy var rootMapView = NMFNaverMapView(frame: contentView.frame)
    var markers = [NMFMarker]()
    
    private lazy var placeView = PlaceView(parentVC: parentVC)
    private let markerImage = UIImage.init(named: "swim-maker")!
    private lazy var makerImageView = NMFOverlayImage(image: markerImage, reuseIdentifier: "swim-maker")

    // MARK: - Init
    init(currentLocation: CLLocationCoordinate2D, parentVC: MapViewController?) {
        self.parentVC = parentVC
        super.init()
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

    public func configureAuthDelegate(target: NMFAuthManagerDelegate) {
        NMFAuthManager.shared().delegate = parentVC
    }
    
    private func configureNMapView() {
        rootMapView.mapView.touchDelegate = parentVC
        rootMapView.showLocationButton = true
        rootMapView.showScaleBar = false
    }
    
    /// 마커 기본 설정
    private func configureMarker(title: String, marker: NMFMarker) {
        marker.captionText = title
        marker.iconImage = makerImageView
        marker.width = 40
        marker.height = 40
        marker.iconPerspectiveEnabled = true
        marker.isHideCollidedSymbols = true
        marker.isHideCollidedMarkers = true
        marker.iconTintColor = UIColor.blue
    }
    
    // MARK: - Layout
    func layout() {
        layoutMapView()
        layoutPlaceView()
    }
    
    private func layoutPlaceView() {
        contentView.addSubview(placeView)
        placeView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func layoutMapView() {
        contentView.addSubview(rootMapView)
        rootMapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    // MARK: - Marker
    
    /// `Map Marker` 단일 추가 메소드
    public func setMarkerOnMap(place: MapPlace) -> NMFMarker {
        let marker = NMFMarker()
        if let coordinator = place.getCoordinator() {
            marker.position = NMGLatLng(lat: coordinator.latitude, lng: coordinator.longitude)
            configureMarker(title: place.placeName, marker: marker)
            marker.userInfo = [
                "id": place.id,
                "title": place.placeName
            ]
            markerTouchHandler(place: place,
                               coordinator: coordinator,
                               marker: marker)
        }
        return marker
    }
    
    /// 마커 터치 액션
    private func markerTouchHandler(place: MapPlace,
                                    coordinator: CLLocationCoordinate2D,
                                    marker: NMFMarker) {
        marker.touchHandler = { [weak self] (_) -> Bool in
            self?.showPlaceInfoView(place: place)
            self?.updateCamera(coordinator)
            return true
        }
    }
    
    /// 지도 마커 업데이트.
    public func placeMarker(locations: [MapPlace]) {
        self.markers.removeAll()
        locations.forEach { place in
            let marker = setMarkerOnMap(place: place)
            marker.mapView = rootMapView.mapView
            self.markers.append(marker)
        }
    }
    
    // MARK: - Place Info View
    
    /// 하단 장소 정보 뷰 보이기
    public func showPlaceInfoView(place: MapPlace) {
        self.placeView.isHidden = false
        self.placeView.setData(data: place)
    }
    
    /// 하단 장소 정보 뷰 숨기기
    public func hidePlaceInfoView() {
        self.placeView.isHidden = true
    }
    
    // MARK: - Camera
    
    /// 카메라 이동
    public func updateCamera(_ location: CLLocationCoordinate2D) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
    
    static let view = NaverMapView(currentLocation: TestLocationObject.coordinatorGuroGu, parentVC: nil)
    static let parentVC = MapViewController(viewModel: parentVCViewModel)
    static let parentVCViewModel = PoolViewModel(locationManager: .shared,
                                                    regionSearchManager: .init())
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(width: 393)
        .onAppear {
            view.configureAuthDelegate(target: parentVC)
        }
    }
}
#endif
