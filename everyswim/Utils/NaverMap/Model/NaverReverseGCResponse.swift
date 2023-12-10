//
//  NaverReverseGCResponse.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation

struct NaverReverseGCResponse: Codable {
    let results: [ReverseGCResult]
}

struct ReverseGCResult: Codable {
    let region: Region
    
    struct Region: Codable {
        let area1: Area
        let area2: Area
    }
    
    struct Area: Codable {
        let name: String
        let coords: Coordinates
        
        struct Coordinates: Codable {
            let center: Center
            
            struct Center: Codable {
                let crs: String
                let x: Double
                let y: Double
            }
        }
    }
}
