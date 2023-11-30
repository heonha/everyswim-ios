//
//  NaverLocationResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/1/23.
//

import Foundation

struct NaverLocationResponse: Codable {
    let total: Int
    let start: Int
    let display: Int
    let items: [NaverLocation]
}

struct NaverLocation: Codable {
    let title: String
    let link: String
    let telephone: String
    let address: String
    let roadAddress: String
    
    let mapx: Int
    let mapy: Int
}
