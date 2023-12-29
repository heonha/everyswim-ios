//
//  VideoCollectionData.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/9/23.
//

import Foundation

struct VideoCollectionResponse: Decodable {
    let video: [VideoCollectionData]
}

struct VideoCollectionData: Decodable, RecommandCollectionProtocol {
    var title: String?
    var subtitle: String?
    let id: String
    let type: String
    let url: String
    let imageUrl: String
}
