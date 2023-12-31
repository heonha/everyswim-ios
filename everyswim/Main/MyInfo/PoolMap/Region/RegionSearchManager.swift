//
//  RegionSearchManager.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation
import Combine
import CoreLocation

class RegionSearchManager {
    
    struct Constant {
        static let citiesBaseUrl = "https://storage.googleapis.com/everyswim-80793.appspot.com/public/api/cities.json"
        static let gcBaseUrl = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"
        static let regionCacheKey = "region-cache"
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentCityCode: SingleRegion = .init(code: 11, name: "서울시", district: "구로구")
    var regionsSubject: CurrentValueSubject<[KrRegions], Never> = .init([])
    
    private let networkService = NetworkService.shared
    
    init() {
        checkRegionCache()
    }
    
    /// 캐시된 리전이 있는지 확인합니다.
    private func checkRegionCache() {
        let data = UserDefaults.standard.data(forKey: Constant.regionCacheKey)
        guard let data = data else {
            getAllRegions()
            return
        }
        
        let region = try? JSONDecoder().decode([KrRegions].self, from: data)

        guard let region = region else {
            getAllRegions()
            return
        }
        
        regionsSubject.send(region)
    }
    
    /// 리전데이터를 캐시합니다.
    private func cachingRegions(region: [KrRegions]) {
        let data = try? JSONEncoder().encode(region)
        UserDefaults.standard.setValue(data, forKey: Constant.regionCacheKey)
    }
    
    /// [API Call] 모든 리전을 가져오고 캐시합니다.
    public func getAllRegions() {
        networkService
            .request(method: .GET,
                     headerType: .applicationJson,
                     urlString: Constant.citiesBaseUrl,
                     endPoint: "",
                     parameters: [:],
                     returnType: RegionAPIResponse.self)
            .receive(on: DispatchQueue.main)
            .filter { !$0.cities.isEmpty }
            .prefix(1)
            .map(\.cities)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] data in
                print("DATA: \(data)")
                guard let self = self else {return}
                regionsSubject.send(data)
                cachingRegions(region: data)
            }
            .store(in: &cancellables)
    }
    
    /// [API Call] Coordinator를 기준으로 주소를 가져옵니다.
    public func getAddressFromCoordinator(_ coordinator: CLLocationCoordinate2D,
                                          completion: @escaping (Result<SingleRegion, Error>) -> Void) {
        
        guard !coordinator.latitude.isZero || !coordinator.longitude.isZero else { return }
        let apikey = SecretConstant.kakaoRestAPIKey
        let urlString = Constant.gcBaseUrl
        
        let parameters = [
            "x": coordinator.longitude,
            "y": coordinator.latitude
        ]
        
        networkService.request(method: .GET,
                               headerType: .applicationJsonWithAuthorization(apikey: apikey),
                               urlString: urlString,
                               endPoint: "",
                               parameters: parameters,
                               returnType: KakaoRegionResponse.self)
        .map(\.data)
        .map {
            $0.filter { region in region.regionType == "H" }
        }
        .retry(3)
        .receive(on: DispatchQueue.main)
        .sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                completion(.failure(error))
            }
        } receiveValue: { [weak self] regions in
            guard let self = self else { return }
            guard let region = regions.first else { completion(.failure(RegionSearchError.responseIsNil)); return }
            let code = cityNameToCode(city: region.oneDepthName)
            let regionViewModel = SingleRegion(code: code, name: region.oneDepthName, district: region.twoDepthName)
            completion(.success(regionViewModel))
        }
        .store(in: &cancellables)
    }
    
    public func cityNameToCode(city: String) -> Int {
        
        let cities = [
            "서울": 11,
            "부산": 21,
            "인천": 22,
            "대구": 23,
            "광주": 24,
            "대전": 25,
            "울산": 26,
            "경기": 31,
            "강원": 32,
            "충북": 33,
            "충남": 34,
            "전북": 35,
            "전남": 36,
            "경북": 37,
            "경남": 38,
            "제주": 39,
            "세종": 41
        ]
        
        let cityCode = cities.first { key, _ in
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
    
    enum RegionSearchError: Error {
        case responseIsNil
    }
    
    /// `구가 있는 도시` 인지 확인
    public func isHasGu(cityCode: Int) -> Bool {
        if cityCode < 29 {
            return true
        } else {
            return false
        }
    }
    
    func replaceSimpleCityName(city: String) -> String {        
        let city = city
            .replacingOccurrences(of: "특별시", with: "시", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "광역시", with: "시", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "특별자치도", with: "시", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "특례시", with: "시", options: .regularExpression, range: nil)
        
        return city
    }
    
}
