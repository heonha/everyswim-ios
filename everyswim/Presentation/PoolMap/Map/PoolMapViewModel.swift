//
//  RegionListViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation
import CoreLocation
import Combine

class PoolMapViewModel {
    
    let locationManager: DeviceLocationManager
    private let regionSearchManager: RegionSearchManager
    private let kakaoLocationManager = KakaoPlacesManager()

    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    
    @Published var searchText: String = ""
    
    var regions: CurrentValueSubject<[KrRegions], Never> {
        return regionSearchManager.regionsSubject
    }
    
    /// 현재 지역 (GPS 기준)
    private var currentLocation: CLLocationCoordinate2D?

    /// `현위치 기준모드인지 확인`
    /// - 타 지역 검색 시 true
    /// - 현 GPS 지역인 경우 false
    @Published var customLoationMode = false
    
    /// targetCurrentLocation데이터를 기준으로 변환된 지역객체.
    @Published var currentRegion: SingleRegion
    
    /// 검색기준 Location
    @Published var targetCurrentLocation: CLLocationCoordinate2D
    
    /// 위치 검색결과
    @Published var places: [MapPlace] = []

    // MARK: - Init & Lifecycles
    init(locationManager: DeviceLocationManager,
         networkService: NetworkService = .shared,
         currentRegion: SingleRegion = .init(code: 0, name: "", district: ""),
         currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
         regionSearchManager: RegionSearchManager) {
        
        self.locationManager = locationManager
        self.networkService = networkService
        self.currentRegion = currentRegion
        self.currentLocation = currentLocation
        self.targetCurrentLocation = currentLocation
        self.regionSearchManager = regionSearchManager
        
        getCurrentLocation()
        observe()
    }
    
    // MARK: - Observe
    private func observe() {
        observeCurrentRegion()
        observeCurrentLocation()
    }
    
    /// 현위치가 바뀌면 장소를 재검색합니다.
    private func observeCurrentRegion() {
        $currentRegion
            .receive(on: DispatchQueue.main)
            .filter { !$0.name.isEmpty }
            .sink { [weak self] _ in
                self?.findLocation()
            }
            .store(in: &cancellables)
    }
    
    /// 현위치가 바뀌면 장소를 재검색합니다.
    private func observeCurrentLocation() {
        locationManager.locationPublisher
            .receive(on: DispatchQueue.main)
            .replaceError(with: .init(latitude: 0, longitude: 0))
            .sink(receiveValue: { [weak self] coordinator in
                self?.targetCurrentLocation = coordinator
                self?.currentLocation = coordinator
                self?.getAddressFromCoordinator(coordinator)
            })
            .store(in: &cancellables)
    }

    /// `현 위치`로 리셋
    public func resetCurrentLocation() {
        guard let currentLocation = currentLocation else { return}
        self.targetCurrentLocation = currentLocation
        self.customLoationMode = false
    }

    private func buildQueryString(from query: String) -> String {
        var query = query
        if query.isEmpty {
            let isHasGu = regionSearchManager.isHasGu(cityCode: currentRegion.code)
            let district = currentRegion.district
            
            if isHasGu {
                let simpleCityName = regionSearchManager.replaceSimpleCityName(city: currentRegion.name)
                query = "\(simpleCityName)\(district)"
            } else {
                query = "\(district)"
            }
        }
        return query
    }
    
    /// `KakaoAPI` 키워드 장소 검색을 요청합니다.
    func findLocation(query: String = "", startCount: Int = 1) {

        let queryString = buildQueryString(from: query)

        kakaoLocationManager
            .findPlaceFromKeyword(query: queryString,
                                  numberOfPage: startCount,
                                  coordinator: targetCurrentLocation,
                                  sort: customLoationMode ? .accuracy : .distance
            ) { [weak self] result in
                switch result {
                case .success(let places):
                    self?.places = places
                case .failure(let error):
                    // TODO: 에러 문구 띄우기
                    self?.places = []
                }
            }
        
    }
    
    /// 좌표값을 기준으로 주소를 가져옵니다.
    public func getAddressFromCoordinator(_ coordinator: CLLocationCoordinate2D) {
        regionSearchManager.getAddressFromCoordinator(coordinator) { result in
            switch result {
            case .success(let regionData):
                self.currentRegion = regionData
            case .failure(let error):
                print("좌표값 기준으로 주소가져오기 에러: \(error)")
            }
        }
    }

    /// "시 / 도" 이름을 코드로 변환합니다.
    public func cityNameToCode(city: String) -> Int {
        regionSearchManager.cityNameToCode(city: city)
    }

}

// MARK: - Map
extension PoolMapViewModel {
    
    func getCurrentLocation() {
        locationManager.requestLocationAuthorization()
    }
    
}
