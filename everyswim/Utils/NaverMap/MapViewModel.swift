//
//  MapViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/30/23.
//

import Foundation
import Combine
import CoreLocation

final class MapViewModel: CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    private let locationManager: DeviceLocationManager
    private let locationViewModel = LocationsViewModel()
    
    @Published var currentRegion: String = ""
    
    private struct Constant {
        static let baseUrl = "https://openapi.naver.com/v1/search/local.json"
    }
    
    private let networkService: NetworkService
    
    @Published var searchText: String = ""
    @Published var poolList: [String] = []
    @Published var currentLoction: CLLocationCoordinate2D
    
    init(networkService: NetworkService = .shared, locationManager: DeviceLocationManager) {
        self.currentLoction = .init(latitude: 0, longitude: 0)
        self.networkService = networkService
        self.locationManager = locationManager
        self.getCurrentLocation()
        self.observeCurrentLocation()
    }
    


}

extension MapViewModel {
    
    func getCurrentLocation() {
        locationManager.requestLocationAuthorization()
    }
    
    func observeCurrentLocation() {
        locationManager.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complteion in
                switch complteion {
                case .finished:
                    return
                case .failure(let error):
                    print("위치 받아오기 에러: \(error)")
                }
            }, receiveValue: { [weak self] location in
                print("위치 업데이트 \(location)")
                self?.currentLoction = location
            })
            .store(in: &cancellables)
    }
    
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
        .map({ region in
            return "\(region.area1.name) \(region.area2.name)"
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
            print(regionData)
            self?.currentRegion = regionData
        }
        .store(in: &cancellables)
    }
    
    /// 장소를 검색 합니다.
    func requestLocationQuery(queryString: String, displayCount: Int = 10, startCount: Int = 1) {
        let url = "\(Constant.baseUrl)?query=\(queryString)&display=\(displayCount)&start=\(startCount)"
        
        networkService.request(method: .GET,
                               headerType: .naverDevInfo(clientId: SecretConstant.NAVER_DEV_CLIENT_ID,
                                                         clientSecret: SecretConstant.NAVER_DEV_CLIENT_SECRET),
                               urlString: url,
                               endPoint: "",
                               parameters: [:],
                               returnType: NaverLocationResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                }
            } receiveValue: { responseData in
                print(responseData)
            }
            .store(in: &cancellables)
    }
    
}
