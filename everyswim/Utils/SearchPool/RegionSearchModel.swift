//
//  RegionSearchModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation
import Combine

class RegionSearchModel {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentRegionCode = ""
    
    private let networkService = NetworkService.shared
    
    func getAllRegions() {
        
        let baseUrl = "https://api.odcloud.kr/api/15067469/v1/uddi:13d0a493-2417-4aee-a5d2-9f068fe399bc"
        
        let parameters: [String: Any] = 
        ["page": 1,
         "perPage": 17,
         "returnType": "json",
         "serviceKey": SecretConstant.KOREA_API_REGION
        ]
        
        networkService
            .request(method: .GET,
                     headerType: .applicationJson,
                     urlString: baseUrl,
                     endPoint: "",
                     parameters: parameters,
                     returnType: RegionResponse.self)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] data in
                print("DATA: \(data)")
                guard let self = self else {return}
                guard let firstData = data.first else { return }
                self.currentRegionCode = firstData.code
            }
            .store(in: &cancellables)
    }
    
    
    
}

struct RegionResponse: Codable {
    let data: [Region]
}

struct Region: Codable {
    let code: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "코드"
        case name = "코드명"
    }
}
