//
//  NaverLocationResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/1/23.
//

import Foundation
import CoreLocation

struct NaverLocationResponse: Codable {
    let total: Int
    let start: Int
    let display: Int
    let items: [NaverLocation]
}

struct NaverLocation: Codable {
    var id: String { return name + mapx + mapy }
    var name: String { return title.cleanLocationName() }
    var link: String?
    let category: String
    
    // 장소 정보
    let telephone: String?
    let address: String
    let roadAddress: String
    
    // 위치
    private let mapx: String
    private let mapy: String
    
    var coordinator: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: mapy.toCoordinate(), longitude: mapx.toCoordinate())}
    
    private let title: String
    var isPool: Bool {
        if category.contains("수영장") {
            return true
        } else {
            return false
        }
    }
}
