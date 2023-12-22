//
//  KakaoPlaceResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/18/23.
//

import Foundation

struct KakaoPlaceResponse: Codable {
    let places: [KakaoPlace]
    
    enum CodingKeys: String, CodingKey {
        case places = "documents"
    }
}

struct KakaoPlace: Codable {
    let id: String
    let placeName: String
    let categoryName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let phone: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let placeURL: String
    let distance: String?
    
    func distanceWithUnit() -> String {
        guard let distance = distance else {return ""}
        guard let distanceDouble = distance.toDouble() else {return ""}
        
        let distanceString: String = {
            if distanceDouble > 1000 {
                let killometer = distanceDouble / 1000
                return killometer.toRoundupString(maxDigit: 1) + "km"
            } else {
                return distanceDouble.toRoundupString() + "m"
            }
        }()
        
        return distanceString
    }
    
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
