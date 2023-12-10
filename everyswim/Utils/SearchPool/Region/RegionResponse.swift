//
//  RegionResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation

struct RegionResponse: Codable {
    let cities: [Region]
}

struct Region: Codable {
    let code: String
    let name: String
    let districts: [String]
}

struct RegionViewModel: Codable {
    let code: Int
    let name: String
    let district: String
}
