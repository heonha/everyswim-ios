//
//  RecommandDataService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/7/23.
//

import Foundation
import Combine

final class RecommandDataService: CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let networkService: NetworkService
    
    private let baseUrl = "https://everyswim-80793.web.app"
    
    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // 추천 영상 API호출 -> 데이터 반환
    func fetchVideo(completion: @escaping ([VideoCollectionData]) -> Void) {
        networkService.request(method: .GET, headerType: .applicationJson, urlString: baseUrl, endPoint: "/sources/video.json", parameters: [:], returnType: VideoCollectionResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("❗️RecommandDataService-\(#function) 완료")
                    break
                case .failure(let error):
                    print("❗️RecommandDataService-\(#function) Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                print("RecommandDataService: \(#function): \(response)")
                let videoData = response.video
                completion(videoData)
            }
            .store(in: &cancellables)
    }
    
    
    // 추천 영상 API호출 -> 데이터 반환
    func fetchCommunity(completion: @escaping ([CommunityCollectionData]) -> Void) {
        networkService.request(method: .GET, headerType: .applicationJson, urlString: baseUrl, endPoint: "/sources/community.json", parameters: [:], returnType: CommunityCollectionResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("❗️RecommandDataService-\(#function) 완료")
                    break
                case .failure(let error):
                    print("❗️RecommandDataService-\(#function) Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                print("RecommandDataService: \(#function): \(response)")
                let communityData = response.community
                completion(communityData)
            }
            .store(in: &cancellables)
    }
    
    
}
