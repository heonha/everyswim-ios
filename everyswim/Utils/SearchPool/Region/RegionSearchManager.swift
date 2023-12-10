//
//  RegionSearchManager.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation
import Combine

class RegionSearchManager {
    
    struct Constant {
        static let baseUrl = "https://storage.googleapis.com/everyswim-80793.appspot.com/public/api/cities.json"
        static let regionCacheKey = "region-cache"
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentCityCode: RegionViewModel = .init(code: 11, name: "서울시", district: "구로구")
    var regionsSubject: CurrentValueSubject<[Region], Never> = .init([])
    
    private let networkService = NetworkService.shared
    
    init() {
        checkRegionCache()
    }
    
    private func checkRegionCache() {
        let data = UserDefaults.standard.data(forKey: Constant.regionCacheKey)
        guard let data = data else {
            getAllRegions()
            return
        }
        
        let region = try? JSONDecoder().decode([Region].self, from: data)

        guard let region = region else {
            getAllRegions()
            return
        }
        
        regionsSubject.send(region)
    }
    
    private func cachingRegions(region: [Region]) {
        let data = try? JSONEncoder().encode(region)
        UserDefaults.standard.setValue(data, forKey: Constant.regionCacheKey)
    }
    
    func getAllRegions() {
        networkService
            .request(method: .GET,
                     headerType: .applicationJson,
                     urlString: Constant.baseUrl,
                     endPoint: "",
                     parameters: [:],
                     returnType: RegionResponse.self)
            .receive(on: DispatchQueue.main)
            .filter { !$0.cities.isEmpty }
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
    
}
