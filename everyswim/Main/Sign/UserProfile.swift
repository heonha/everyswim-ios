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

}
