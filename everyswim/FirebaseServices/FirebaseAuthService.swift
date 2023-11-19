//
//  FirebaseAuthService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/10/23.
//

import Foundation
import CryptoKit
import FirebaseAuth

final class FirebaseAuthService {
    
    // MARK: - Init
    init() {
        
    }
    
    // MARK: - Sign In
    /// Firebase를 통한 로그인 요청
    func firebaseSignIn(with credential: OAuthCredential) async throws {
        let service = FireStoreDBService()
        do {
            let signResult = try await Auth.auth().signIn(with: credential)
            
            let isExist = try await service.checkUserProfileExist(user: signResult.user)
            
            if isExist {
                let userProfile = try await service.fetchUserProfile(user: signResult.user)
                AuthManager.shared.signIn(with: userProfile)
            } else {
                try await service.createUserProfile(user: signResult.user, name: "", profileImageUrl: "")
                let fetchedProfile = try await service.fetchUserProfile(user: signResult.user)
                AuthManager.shared.signIn(with: fetchedProfile)
            }
        } catch {
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
            print("DEBUG: 로그아웃 성공")
        } catch {
            print("DEBUG: 로그아웃 에러 \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteAccount(user: User) async throws {
        try await user.delete()
    }
    
    /// 캐시된 currentUser 확인
    func getAuthenticatedUser() -> User? {
        let currentUser = Auth.auth().currentUser
        return currentUser
    }
    
    func getSignInState() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Credentialㅇ
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
}
