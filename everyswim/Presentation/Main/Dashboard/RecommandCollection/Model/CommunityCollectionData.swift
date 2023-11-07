//
//  CommunityCollectionData.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/7/23.
//

import Foundation

struct CommunityCollectionResponse: Codable {
    let community: [CommunityCollectionData]
}

struct CommunityCollectionData: Codable {
    let title: String
    let description: String
    let url: String
    let imageUrl: String
}
