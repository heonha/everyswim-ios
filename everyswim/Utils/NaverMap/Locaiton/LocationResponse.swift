//
//  LocationResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation
import CoreLocation

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
    private let mapx: String
    private let mapy: String

    var coordinator: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: mapy.toCoordinate(), longitude: mapx.toCoordinate())}
    
    private let title: String
    var isPool: Bool {
        return category.contains("수영장") || category.contains("스포츠시설")
    }
    
}


extension String {
    
    func toCoordinate() -> Double {
        guard let doubleData = Double(self) else { return 0 }
        return doubleData / 10_000_000
    }
    
}
