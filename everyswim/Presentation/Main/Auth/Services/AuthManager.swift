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
    
    static let shared = AuthManager()
    
    @Published var isSignIn: Bool = false
    
    private var user: UserProfile?
    
    private init(apple: AppleSignInHelper = .init(), fbCredentialService: FirebaseAuthService = .init()) {
        self.appleSignService = apple
        self.fbCredentialService = fbCredentialService
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
    
    
    // MARK: - Manage Session
    
    /// `세션 상태`를 반환합니다.
    func getSignInState() -> Bool {
        return fbCredentialService.getSignInState()
    }
    
    /// 세션상태를  확인하고 UserProfile을 업데이트합니다.
    func getCurrentUserSession() {
        do {
            guard fbCredentialService.getSignInState() == true else {
                throw SignInError.sessionExpired
            }
            
            let user = try fetchCurrentUserData()
            signIn(with: user)
            
        } catch {
            
            Task {
                do {
                    try await fbCredentialService.signOut()
                } catch {
                    print(error.localizedDescription)
                }
                print("세션 끊김: \(error.localizedDescription)")
            }
            
        }
    }

    /// Firebase에서 인증된 Current User 가져오기
    func fetchCurrentUserData() throws -> UserProfile {
        do {
            let user = try fbCredentialService.getAuthenticatedUser()
            let userProfile = UserProfile(uid: user.uid, name: user.displayName, email: user.email, providerId: user.providerID, profileImageUrl: "https://cdn.vox-cdn.com/thumbor/6S_BERxoDvfZqF05MW_gEiIpewk=/0x0:1033x689/1400x1400/filters:focal(517x345:518x346)/cdn.vox-cdn.com/uploads/chorus_asset/file/11701871/ive.png")
            self.user = userProfile
            print("세션 유저 프로필 가져왔습니다.")
            return userProfile
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getEmail() -> String? {
        return self.user?.email
    }
    
    func getMyInfoProfile() -> MyInfoProfile {
        guard getSignInState() == true else {
            return MyInfoProfile(name: "로그아웃 물개", email: "로그인 하기", imageUrl: nil)
        }
        guard let user = user else {
            return MyInfoProfile(name: "로그아웃 물개", email: "로그인 하기", imageUrl: nil)
        }
        
        return MyInfoProfile(name: user.name ?? "로그인한 물개", email: user.email ?? "알수없는 이메일", imageUrl: user.profileImageUrl)
    }
    
}
