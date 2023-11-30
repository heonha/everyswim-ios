//
//  MapViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/30/23.
//

import Foundation
import Combine

final class NMapViewModel: CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private struct Constant {
        static let baseUrl = "https://openapi.naver.com/v1/search/local.json"
    }
    
    private let networkService: NetworkService
    
    @Published var searchText: String = ""
    @Published var poolList: [String] = []
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
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
