//
//  LocationResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation

struct LocationResponse: Codable {
    
    let items: [Location]
    
}

struct Location: Identifiable, Codable {
    
    var id: String { return name + mapx + mapy }
    var name: String { return title.cleanLocationName() }
    var link: String?
    let category: String
    
    // 장소 정보
    let telephone: String?
    let address: String
    let roadAddress: String
    
    // 위치
    let mapx: String
    let mapy: String

    private let title: String
    var isPool: Bool {
        return category.contains("수영장") || category.contains("스포츠시설")
    }
    
}
