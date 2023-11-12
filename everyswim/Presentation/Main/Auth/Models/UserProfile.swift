//
//  UserProfile.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/10/23.
//

import Foundation

struct UserProfile {
    
    let uid: String
    let name: String?
    let email: String?
    let providerId: String
    let profileImageUrl: String?
    
    init(uid: String, name: String?, email: String?, providerId: String, profileImageUrl: String?) {
        self.uid = uid
        self.name = name
        self.email = email
        self.providerId = providerId
        self.profileImageUrl = profileImageUrl
    }
    
}
