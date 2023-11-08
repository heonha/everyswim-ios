//
//  RecommandCollectionProtocol.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/8/23.
//

import Foundation

protocol RecommandCollectionProtocol {
    var title: String? { get }
    var subtitle: String? { get }
    var url: String { get }
    var imageUrl: String { get }
}
