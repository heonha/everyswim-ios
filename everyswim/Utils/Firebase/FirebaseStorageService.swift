//
//  FirebaseStorage.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/18/23.
//

import UIKit
import FirebaseStorage

final class FirebaseStorageService {
    
    private struct Constant {
        static let storage = Storage.storage()
        static let publicUsersDir = storage.reference().child("public").child("user")
        static let userProfileImageName = "profile-image.jpg"
    }
    
    /// 프로필  이미지 업로드
    func uploadProfileImage(uid: String, image: Data) async throws -> String {
        
        print("FIREBASE STORAGE SET---------")
        print("\(Constant.publicUsersDir.bucket)")

        let userHomeDir = Constant.publicUsersDir.child(uid)
        let imageFileRef = userHomeDir.child(Constant.userProfileImageName)
        
        do {
            print("데이터 put시작")
            let profileImage = try await imageFileRef.putDataAsync(image, metadata: nil)
            print("데이터 put완료")
            let size = profileImage.size
            print(size)
            let downloadUrl = try await imageFileRef.downloadURL()
            return downloadUrl.absoluteString
        } catch {
            throw error
        }
    }
    
    func updateProfileImage(uid: String, image: Data) async throws -> String {
        
        print("FIREBASE STORAGE SET---------")
        print("\(Constant.publicUsersDir.bucket)")

        let userHomeDir = Constant.publicUsersDir.child(uid)
        let imageFileRef = userHomeDir.child(Constant.userProfileImageName)
        
        do {
            print("데이터 delete시작")
            try await imageFileRef.delete()
            print("데이터 delete완료")
            print("데이터 put시작")
            let profileImage = try await imageFileRef.putDataAsync(image, metadata: nil)
            print("데이터 put완료")
            let size = profileImage.size
            print(size)
            let downloadUrl = try await imageFileRef.downloadURL()
            return downloadUrl.absoluteString
        } catch {
            throw error
        }
    }

}

enum FirebaseStorageError: ESError {
    case uidIsNil(location: String)
    case dataIsNil(location: String)
    
    var message: String {
        switch self {
        case .uidIsNil(let location):
            return "UID가 없습니다. \(location)"
        case .dataIsNil(let location):
            return "DATA가 없습니다. \(location)"
        }
    }
    
    var location: String {
        switch self {
        case .uidIsNil(let location):
            return location
        case .dataIsNil(let location):
            return location
        }
    }

}
