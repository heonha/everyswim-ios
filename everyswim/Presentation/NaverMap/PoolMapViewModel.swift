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
    
    @Published var currentRegion: SingleRegion
    @Published var currentLoction: CLLocationCoordinate2D
    @Published var pools: [KakaoPlace] = []

    // MARK: - Init & Lifecycles
    init(locationManager: DeviceLocationManager,
         networkService: NetworkService = .shared,
         currentRegion: SingleRegion = .init(code: 0, name: "", district: ""),
         currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
         regionSearchManager: RegionSearchManager
    ) {
        
        self.locationManager = locationManager
        self.networkService = networkService
        self.currentRegion = currentRegion
        self.currentLoction = currentLocation
        self.regionSearchManager = regionSearchManager
        getCurrentLocation()
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
                self?.currentLoction = coordinator
                self?.getAddressFromCoordinator(coordinator)
            })
            .store(in: &cancellables)
    }
    
    func replaceSimpleCityName(city: String) -> String {
        let city = city
            .replacingOccurrences(of: "특별시", with: "시", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "광역시", with: "시", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "특별자치도", with: "시", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "특례시", with: "시", options: .regularExpression, range: nil)
        
        return city
    }
    
    /// 구가 있는 도시 인지 확인함
    func isHasGu(cityCode: Int) -> Bool {
        if cityCode < 29 {
            return true
        } else {
            return false
        }
    }
    
    /// `KakaoAPI` 키워드 장소 검색을 요청합니다.
    func findLocation(queryString: String? = nil, displayCount: Int = 15, startCount: Int = 1) {
        var queryString = queryString
        if queryString == nil {
            if isHasGu(cityCode: currentRegion.code) {
                queryString = "\(replaceSimpleCityName(city: currentRegion.name))\(currentRegion.district)수영장"
            } else {
                queryString = "\(currentRegion.district)수영장"
            }
        }
        guard let queryString = queryString else { return }
        
        kakaoLocationManager.findPlaceFromKeyword(query: queryString, 
                                                  numberOfPage: startCount,
                                                  countOfPage: displayCount,
                                                  coordinator: currentLoction) { [weak self] result in
            switch result {
            case .success(let places):
                self?.pools = places
            case .failure(let error):
                self?.pools = []
                print("ERROR\(error)")
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
