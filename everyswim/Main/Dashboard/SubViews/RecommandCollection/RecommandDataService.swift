//
//  RecommandDataService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/7/23.
//

import Foundation
import Combine

final class RecommandDataService {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let networkService: NetworkService
    
    private let baseUrl = "https://everyswim-80793.web.app"
    
    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }
    
    private func fetchJSONData<T: Decodable>(endPoint: String, completion: @escaping(Result<T, Error>) -> Void) {
        networkService.request(method: .GET,
                               headerType: .applicationJson,
                               urlString: baseUrl,
                               endPoint: endPoint,
                               parameters: [:],
                               cachePolicy: .useProtocolCachePolicy,
                               returnType: T.self)
        .timeout(10, scheduler: DispatchQueue.global())
        .retry(3)
        .receive(on: DispatchQueue.main)
        .sink { result in
            print(result)
            switch result {
            case .finished:
                break
            case .failure(let error):
                completion(.failure(error))
            }
        } receiveValue: { response in
            let videoData = response
            completion(.success(videoData))
        }
        .store(in: &cancellables)
    }
    
    // 추천 영상 API호출 -> 데이터 반환
    func fetchVideo(completion: @escaping (Result<[VideoCollectionData], Error>) -> Void) {
        fetchJSONData(endPoint: "/sources/video.json") { (result: Result<VideoCollectionResponse, Error>) in
            switch result {
            case .success(let response):
                let data = response.video
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 추천 영상 API호출 -> 데이터 반환
    func fetchCommunity(completion: @escaping (Result<[CommunityCollectionData], Error>) -> Void) {
        fetchJSONData(endPoint: "/sources/community.json") { (result: Result<CommunityCollectionResponse, Error>) in
            switch result {
            case .success(let response):
                let data = response.community
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
