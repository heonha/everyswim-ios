//
//  KakaoRegionResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/18/23.
//

import Foundation

struct KakaoRegionResponse: Codable {
    let data: [KakaoRegion]
    
    private enum CodingKeys: String, CodingKey {
        case data = "documents"
    }
}

struct KakaoRegion: Codable {
    let regionType: String
    let oneDepthName: String
    let twoDepthName: String
    let threeDepthName: String
    
    private enum CodingKeys: String, CodingKey {
        case regionType = "region_type"
        case oneDepthName = "region_1depth_name"
        case twoDepthName = "region_2depth_name"
        case threeDepthName = "region_3depth_name"
    }
    
}
