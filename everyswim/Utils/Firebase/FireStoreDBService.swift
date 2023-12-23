//
//  FireStoreDBService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FireStoreDBService {
    
    private let fireStore = Firestore.firestore()
    private let userProfileCollection = Firestore.firestore().collection("user-profile")
    
    /// 유저 프로필 데이터 생성
    func createUserProfile(user: User, name: String, profileImageUrl: String = "") async throws {
        print("\(#function)")
        let userProfile = UserProfile(email: user.email,
                                      providerId: user.providerID,
                                      name: name,
                                      profileImageUrl: profileImageUrl,
                                      signUpDate: Date().toString(.timeStamp),
                                      lastUpdated: Date().toString(.timeStamp)
        )
        
        do {
            print("\(#function): set DATA")
            try userProfileCollection.document(user.uid).setData(from: userProfile)
        } catch {
            let eserror = error as? ESError
            print("DEBUG: 유저정보 저장 오류: \(String(describing: eserror?.message))")
            throw error
        }
    }
    
    /// 유저 프로필 데이터 업데이트
    func updateUserProfile(uid: String, name: String, profileImageUrl: String?) async throws {
        do {
            print("\(#function): update Profile DATA")
            let updateData = makeUpdateUserProfileData(uid: uid, name: name, profileImageUrl: profileImageUrl)
            try await userProfileCollection.document(uid).updateData(updateData)
        } catch {
            let eserror = error as? ESError
            print("DEBUG: 유저정보 저장 오류: \(String(describing: eserror?.message))")
            throw error
        }
    }
    
    /// 업데이트 프로필 데이터 핸들링
    private func makeUpdateUserProfileData(uid: String, 
                                           name: String,
                                           profileImageUrl: String?) -> [AnyHashable: Any] {
        guard let profileImageUrl = profileImageUrl else {
            return ["name": name,
                    "lastUpdated": Date().toString(.timeStamp)]
        }
        
        return ["name": name,
                "profileImageUrl": profileImageUrl,
                "lastUpdated": Date().toString(.timeStamp)]
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
    
    func deleteUserProfile(user: User) async throws {        
        try await userProfileCollection.document(user.uid).delete()
    }
    
}

extension FireStoreDBService {
    
    enum FireStoreServiceError: ESError {
        
        case decodingError(location: String = #function)
        
        // DB Mismatc
        case duplicateUserId(location: String = #function)
        
        // Fail To Fetch Errors
        case currentUserIsNil(location: String = #function)
        case failSearchUserProfile(location: String = #function)
        case failFetchProfileImageUrl(location: String = #function)

        var message: String {
            switch self {
            case .decodingError:
                return location
            case .failSearchUserProfile:
                return location
            case .duplicateUserId:
                return location
            case .currentUserIsNil:
                return location
            case .failFetchProfileImageUrl:
                return location
            }
        }
        
        var location: String {
            switch self {
            case .decodingError(let location):
                return location
            case .duplicateUserId(let location):
                return location
            case .currentUserIsNil(let location):
                return location
            case .failSearchUserProfile(let location):
                return location
            case .failFetchProfileImageUrl(let location):
                return location
            }
        }
    }

}
