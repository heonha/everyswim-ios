//
//  FireStoreService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FireStoreService {
    
    private let fireStore = Firestore.firestore()
    private let userProfileCollection = Firestore.firestore().collection("user-profile")
    
    func createUserProfile(user: User, name: String, profileImageUrl: String = "") async throws {
        
        let userProfile = UserProfile(email: user.email, 
                                      providerId: user.providerID,
                                      name: name,
                                      profileImageUrl: profileImageUrl,
                                      signUpDate: Date().toString(.timeStamp),
                                      lastUpdated: Date().toString(.timeStamp)
        )
        
        do {
            if try await checkUserProfileExist(user: user) {
                throw FireStoreServiceError.duplicateUserId
            }
            try userProfileCollection.document(user.uid).setData(from: userProfile)
        } catch {
            print("DEBUG: 유저정보 저장 오류: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateUserProfile() {
        
    }
    
    func checkUserProfileExist(user: User) async throws -> Bool {
        let isExist = try await userProfileCollection
            .document(user.uid)
            .getDocument()
            .exists
        
        return isExist
    }
    
    func fetchUserProfile(user: User) async throws -> UserProfile {
        do {
            let userProfile = try await userProfileCollection
                .document(user.uid)
                .getDocument(as: UserProfile.self)
            return userProfile
        } catch {
            throw error
        }
    }
    
    func deleteUserProfile() {
        
    }
    
}

enum FireStoreServiceError: Error {
    case decodingError
    case failSearchUserProfile
    case duplicateUserId

}
