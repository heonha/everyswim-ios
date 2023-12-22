//
//  NetworkService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/7/23.
//

import Foundation
import Combine

final class NetworkService: RestProtocol {
    
    static let shared = NetworkService()
    
    private init() {}
    
    private var session = URLSession.shared
    var cancellables = Set<AnyCancellable>()
    
    func cancel() {
        cancellables = .init()
    }
    
    func request<T>(method: HttpMethod,
                    headerType: HttpHeader,
                    urlString baseUrl: String,
                    endPoint: String,
                    parameters: [String: Any],
                    cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                    returnType: T.Type) -> Future<T, Error> where T: Decodable {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.selfIsNil))
            }
            
            var request: URLRequest
            
            switch method {
            case .GET:
                let urlString = "\(baseUrl)\(endPoint)\(parameterQueryHandler(from: parameters))"
                print("DEBUG urlString: \(urlString)")
                guard let url = URL(string: urlString) else {
                    return promise(.failure(NetworkError.invalidUrl))
                }
                
                request = URLRequest(url: url)
                request.allHTTPHeaderFields = headerType.get()
                request.httpMethod = HttpMethod.GET.rawValue
                request.cachePolicy = cachePolicy
                
            case .POST, .PUT, .DELETE:
                let urlString = "\(baseUrl)\(endPoint)"
                print("DEBUG urlString: \(urlString)")
                guard let url = URL(string: urlString) else {
                    return promise(.failure(NetworkError.invalidUrl))
                }
                
                let queryItems: [URLQueryItem] = parameters
                    .map { item in
                        return URLQueryItem(name: item.key, value: (item.value as! String))
                    }
                
                var bodyComponent = URLComponents()
                bodyComponent.queryItems = queryItems
                let httpBody = bodyComponent.query?.data(using: .utf8)
                
                request = URLRequest(url: url)
                request.allHTTPHeaderFields = headerType.get()
                request.httpMethod = HttpMethod.POST.rawValue
                request.httpBody = httpBody
                request.cachePolicy = cachePolicy

            }
            
            tryDataTaskPublisher(request: request)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.global())
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(error))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0))
                })
                .store(in: &self.cancellables)
        }
    }
    
}

extension NetworkService {
    private func parameterQueryHandler(from parameters: [String: Any]) -> String {
        var queryString = ""
        
        if !parameters.isEmpty {
            queryString += "?"
            
            for parameter in parameters {
                queryString += "\(parameter.key)=\(parameter.value)&"
            }
        }
        
        if queryString.last == "&" {
            queryString.removeLast()
        }
        
        return queryString
    }
    
    // MARK: - Try DataTask Publisher
    private func tryDataTaskPublisher(request: URLRequest) -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        return self.session.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.responseError
                }
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.statusCode(httpResponse.statusCode)
                }
                
                return data
            }
    }
    
}
