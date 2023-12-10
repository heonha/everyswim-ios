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
    
    private var cancellables = Set<AnyCancellable>()
    
    private struct Constant {
        static let baseUrl = "https://openapi.naver.com/v1/search/local.json"
    }

    private let networkService: NetworkService = .shared

    @Published var currentRegion: City
    @Published var currentLoction: CLLocationCoordinate2D

    init(currentRegion: City = .init(name: "서울시", district:"강남구"), currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)) {
        self.currentRegion = currentRegion
        self.currentLoction = currentLocation
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
            print(regionData)
            self?.currentRegion = .init(name: regionData.city, district: regionData.district)
        }
        .store(in: &cancellables)
    }

    
}
