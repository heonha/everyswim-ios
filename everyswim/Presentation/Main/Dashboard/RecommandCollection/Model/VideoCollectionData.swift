//
//  VideoCollectionData.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/9/23.
//

import Foundation

struct VideoCollectionResponse: Codable {
    let video: [VideoCollectionData]
}

struct VideoCollectionData: Codable {
    let id: String
    let type: String
    let url: String
    let imageUrl: String
}
