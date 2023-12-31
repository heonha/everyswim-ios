//
//  KakaoPlacesManager.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/18/23.
//

import Foundation
import Combine
import CoreLocation

final class KakaoPlacesManager {
    
    enum KakaoPlaceSort: String {
        case accuracy
        case distance
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService = NetworkService.shared
    
    /// 키워드 및 장소를 기준으로 주변 수영장을 가져옵니다.
    public func findPlaceFromKeyword(query: String,
                                     numberOfPage: Int = 1, 
                                     countOfPage: Int = 15,
                                     coordinator: CLLocationCoordinate2D?,
                                     sort: KakaoPlaceSort = .distance,
                                     completion: @escaping (Result<[KakaoPlace], Error>) -> Void) {

        let urlString = "https://dapi.kakao.com/v2/local/search/keyword.json"
        
        let apikey = SecretConstant.kakaoRestAPIKey
        let sort = sort.rawValue
        
        var parameters: [String: Any] = [
            "query": query,
            "size": countOfPage,
            "page": numberOfPage,
            "sort": sort
        ]
        
        if let coordinator = coordinator {
            parameters["x"] = coordinator.longitude
            parameters["y"] = coordinator.latitude
        }
        
        networkService.request(method: .GET, 
                               headerType: .applicationJsonWithAuthorization(apikey: apikey),
                               urlString: urlString, 
                               endPoint: "",
                               parameters: parameters,
                               returnType: KakaoPlaceResponse.self)
        .delay(for: 1, scheduler: DispatchQueue.main)
        .map(\.places)
        .map { $0.filter { $0.categoryName.contains("수영장")} }
        .retry(2)
        .receive(on: DispatchQueue.global())
        .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                print("KAKAO 키워드 검색 ERROR: \(error)")
                completion(.failure(error))
            }
        }, receiveValue: { places in
            print(places)
            completion(.success(places))
        })
        .store(in: &cancellables)
        
    }
    
}
