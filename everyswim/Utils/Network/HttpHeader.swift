//
//  HttpHeader.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/7/23.
//

import Foundation

enum HttpHeader {
    
    case applicationJson
    case applicationxwwwformurlencoded
    
    ///"Content-Type": "application/x-www-form-urlencoded",
    ///"Authorization": "Basic \(encodedToken)",
    case basicTokenHeader(clientId: String, clientSecret: String)
    
    ///"Authorization": "Bearer \(encodedToken)",
    case bearerTokenHeader(token: String)
    
    case naverDevInfo(clientId: String, clientSecret: String)
    
    func get() -> [String: String] {
        switch self {
        case .applicationJson:
            return  ["Content-Type": "application/json"]
            
        case .applicationxwwwformurlencoded:
            return  ["Content-Type": "application/x-www-form-urlencoded"]
            
        case .basicTokenHeader(let clientId, let clientSecret):
            let token = clientId + ":" + clientSecret
            let encodedToken = token.data(using: .utf8)?.base64EncodedString() ?? ""
            
            return [
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": "Basic \(encodedToken)",
            ]
        case .bearerTokenHeader(let token):
            return ["Authorization": "Bearer \(token)"]
            
        case .naverDevInfo(let clientId, let clientSecret):
            return [
                "X-Naver-Client-Id": clientId,
                "X-Naver-Client-Secret": clientSecret
            ]
        }
    }
    
}
