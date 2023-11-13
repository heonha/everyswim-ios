//
//  AuthManager.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit
import FirebaseAuth

final class AuthManager: ObservableObject {
    
    private struct Constant {
        static let isSignInKey = "isSignInKey"
    }
    
    private let appleSignService: AppleSignInHelper
    private let fbCredentialService: FirebaseAuthService
    private let fireStoreService: FireStoreService
    
    static let shared = AuthManager()
    
    @Published var isSignIn: Bool = false
    
    private var user: UserProfile?
    
    private init(apple: AppleSignInHelper = .init(), fbCredentialService: FirebaseAuthService = .init(), fireStoreService: FireStoreService = .init()) {
        self.appleSignService = apple
        self.fbCredentialService = fbCredentialService
        self.fireStoreService = fireStoreService
        self.getCurrentUserSession()
    }
    
    // MARK: - SignIn & SignOut
    /// 유저
    func signIn(with user: UserProfile) {
        print(user)
        self.isSignIn = true
        self.user = user
    }
    
    func signOut() throws {
        Task {
            do {
                try await fbCredentialService.signOut()
                self.user = nil
                self.isSignIn = false
            } catch {
                throw error
            }
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            // An error happened.
          } else {
            // Account deleted.
          }
        }
    }
    
    
    // MARK: - Manage Session
    
    /// `세션 상태`를 반환합니다.
    func getSignInState() -> Bool {
        return fbCredentialService.getSignInState()
    }
    
    /// 세션상태를  확인하고 UserProfile을 업데이트합니다.
    func getCurrentUserSession() {
        Task(priority: .userInitiated) {
            do {
                guard fbCredentialService.getSignInState() == true else {
                    throw SignInError.sessionExpired
                }
                let userProfile = try await fetchCurrentUserData()
                self.user = userProfile
                self.isSignIn = true
            } catch {
                do {
                    try await fbCredentialService.signOut()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    /// Firebase에서 인증된 Current User 가져오기
    func fetchCurrentUserData() async throws -> UserProfile {
        do {
            let user = try fbCredentialService.getAuthenticatedUser()
            let userProfile = try await fireStoreService.fetchUserProfile(user: user)
            return userProfile
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getMyInfoProfile() -> MyInfoProfile {
        guard getSignInState() == true, let user = user else {
            return MyInfoProfile(name: "로그아웃 물개", email: "로그인 하기", imageUrl: nil)
        }
        
        return MyInfoProfile(name: user.name ?? "로그인한 물개", email: user.email ?? "알수없는 이메일", imageUrl: user.profileImageUrl)
    }
    
}
