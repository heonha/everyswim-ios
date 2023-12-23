//
//  KakaoPlaceResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/18/23.
//

import Foundation
import CoreLocation

struct KakaoPlaceResponse: Codable {
    let places: [KakaoPlace]
    
    enum CodingKeys: String, CodingKey {
        case places = "documents"
    }
}

struct KakaoPlace: Codable, MapPlace {
    let id: String
    var placeName: String
    let categoryName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let phone: String
    var addressName: String
    var roadAddressName: String
    var x: String
    var y: String
    let placeURL: String
    var distance: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "place_name"
        case categoryName = "category_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case phone
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x
        case y
        case placeURL = "place_url"
        case distance
    }
}
