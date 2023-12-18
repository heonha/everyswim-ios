//
//  RegionListViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation
import CoreLocation
import Combine

class PoolListViewModel {
    
    let locationManager: DeviceLocationManager
    private let regionSearchManager: RegionSearchManager
    private let kakaoLocationManager = KakaoPlacesManager()

    private var cancellables = Set<AnyCancellable>()

    private let networkService: NetworkService
    
    var regions: CurrentValueSubject<[Region], Never> {
        return regionSearchManager.regionsSubject
    }
    
    @Published var currentRegion: RegionViewModel
    @Published var currentLoction: CLLocationCoordinate2D
    @Published var pools: [KakaoPlace] = []

    // MARK: - Init & Lifecycles
    init(locationManager: DeviceLocationManager,
         networkService: NetworkService = .shared,
         currentRegion: RegionViewModel = .init(code: 0, name: "", district:""),
         currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
         regionSearchManager: RegionSearchManager
    ) {
        
        self.locationManager = locationManager
        self.networkService = networkService
        self.currentRegion = currentRegion
        self.currentLoction = currentLocation
        self.regionSearchManager = regionSearchManager
        observeCurrentRegion()
        observeCurrentLocation()
    }
    
    /// 현위치가 바뀌면 장소를 재검색합니다.
    private func observeCurrentRegion() {
        $currentRegion
            .receive(on: DispatchQueue.main)
            .filter { !$0.name.isEmpty }
            .sink { [weak self] city in
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
    func getAddressFromCoordinator(_ coordinator: CLLocationCoordinate2D) {
        let baseUrl = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"

        let parameters = [
            "coords": "\(coordinator.longitude),\(coordinator.latitude)",
            "output": "json",
            "orders": "legalcode"
        ]
        
        networkService.request(method: .GET,
                               headerType: .naverOpenApiInfo(clientId: SecretConstant.NAVER_API_CLIENT_ID,
                                                             clientSecret: SecretConstant.NAVER_API_CLIENT_SECRET),
                               urlString: baseUrl,
                               endPoint: "",
                               parameters: parameters,
                               returnType: NaverReverseGCResponse.self)
        .compactMap(\.results.first?.region)
        .map({ region -> (city: String, district: String) in
            return (region.area1.name, region.area2.name)
        })
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] regionData in
            guard let self = self else {return}
            let cityCode = cityNameToCode(city: regionData.city)
            self.currentRegion = .init(code: cityCode, name: regionData.city, district: regionData.district)
        }
        .store(in: &cancellables)
    }
    
    func cityNameToCode(city: String) -> Int {
        
        let cities = [
            "서울" : 11,
            "부산" : 21,
            "인천" : 22,
            "대구" : 23,
            "광주" : 24,
            "대전" : 25,
            "울산" : 26,
            "경기" : 31,
            "강원" : 32,
            "충북" : 33,
            "충남" : 34,
            "전북" : 35,
            "전남" : 36,
            "경북" : 37,
            "경남" : 38,
            "제주" : 39,
            "세종" : 41
        ]
        
        let cityCode = cities.first { key, value in
            areFirstTwoCharactersEqual(city, key)
        }
        
        guard let cityCode = cityCode else { return 0 }
        
        return cityCode.value
    }
    
    func areFirstTwoCharactersEqual(_ str1: String, _ str2: String) -> Bool {
        guard str1.count >= 2 && str2.count >= 2 else {
            return false
        }
        
        return str1.prefix(2) == str2.prefix(2)
    }
}
