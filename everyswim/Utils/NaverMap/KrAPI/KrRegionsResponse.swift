//
//  KrRegionsResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation

struct KrRegionsResponse: Codable {
    let cities: [KrRegions]
}

struct KrRegions: Codable {
    let code: String
    let name: String
    let districts: [String]
}
