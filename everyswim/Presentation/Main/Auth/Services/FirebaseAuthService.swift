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
    func firebaseSignIn(with credential: OAuthCredential, completion: @escaping(Result<Void, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let userData = authResult?.user.providerData.first {
                let userProfile = UserProfile(uid: userData.uid, name: userData.displayName, email: userData.email, providerId: userData.providerID, profileImageUrl: nil)
                AuthManager.shared.signIn(with: userProfile)
                completion(.success(()))
            } else {
                completion(.failure(SignInError.unknown))
            }
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
    
    /// 캐시된 currentUser 확인
    func getAuthenticatedUser() throws -> User {
        guard let currentUser = Auth.auth().currentUser else {
            throw SignInError.userdataFetchError
        }
        return currentUser
    }
    
    func getSignInState() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: - Credential
    
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
