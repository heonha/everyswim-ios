//
//  DefaultModelProtocol.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/30/23.
//

import Foundation

protocol DefaultModelProtocol {
    
    associatedtype DefaultData
    
    static var `default`: DefaultData {get set}
}
