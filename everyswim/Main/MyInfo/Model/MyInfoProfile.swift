//
//  MyInfoProfile.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/12/23.
//

import Foundation

struct MyInfoProfile: DefaultModelProtocol, TestableObject {
    
    let name: String
    let email: String
    let imageUrl: String?
    
    static var `default`: MyInfoProfile = .init(name: "비 로그인", email: "로그인 하기", imageUrl: nil)
    static var examples =  [MyInfoProfile.init(name: "테스트사용자", email: "test123@testexampleuser.com", imageUrl: nil)]
    
}
