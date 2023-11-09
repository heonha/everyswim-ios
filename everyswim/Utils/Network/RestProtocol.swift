//
//  RestProtocol.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/7/23.
//

import Foundation
import Combine

protocol RestProtocol {
    
    func request<T: Decodable>(
        method: HttpMethod,
        headerType: HttpHeader,
        urlString baseUrl: String,
        endPoint: String,
        parameters: [String: String],
        cachePolicy: URLRequest.CachePolicy,
        returnType: T.Type) -> Future<T, Error>
    
}
