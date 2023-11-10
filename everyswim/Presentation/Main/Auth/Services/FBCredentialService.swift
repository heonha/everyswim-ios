//
//  FBCredentialService.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/10/23.
//

import Foundation
import FirebaseAuth
import CryptoKit

class FBCredentialService {
        
    init() {
        
    }
    
    func firebaseLogin(with credential: OAuthCredential, completion: @escaping(Result<Void, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let userData = authResult?.user.providerData.first {
                let userProfile = UserProfile(uid: userData.uid, name: userData.displayName, email: userData.email, providerId: userData.providerID, profileImageUrl: nil)
                AuthService.shared.signIn(with: userProfile)
                completion(.success(()))
            } else {
                completion(.failure(SignInError.unknown))
            }

            // 사용자가 Apple로 Firebase에 로그인되어 있습니다.
            // ...
        }
    }
    
    
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
