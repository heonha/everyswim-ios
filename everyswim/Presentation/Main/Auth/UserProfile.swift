//
//  UserProfile.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserProfile: Codable {
    
    let email: String?
    let providerId: String

    let name: String?
    let profileImageUrl: String?
    let signUpDate: String
    let lastUpdated: String
    
    init(email: String?, providerId: String, name: String?, profileImageUrl: String?, signUpDate: String, lastUpdated: String) {
        self.name = name
        self.email = email
        self.providerId = providerId
        self.profileImageUrl = profileImageUrl
        self.signUpDate = signUpDate
        self.lastUpdated = lastUpdated
    }
    
}
