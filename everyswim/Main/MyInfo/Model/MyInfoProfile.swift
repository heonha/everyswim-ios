//
//  MyInfoProfile.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/12/23.
//

import Foundation

struct MyInfoProfile: DefaultModelProtocol {
    
    let name: String
    let email: String
    let imageUrl: String?
    
    static var `default`: MyInfoProfile = .init(name: "-", email: "-", imageUrl: nil)
    
}
