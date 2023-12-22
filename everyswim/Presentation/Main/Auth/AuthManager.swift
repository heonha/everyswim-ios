//
//  AuthManager.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/9/23.
//

import UIKit
import Combine
import FirebaseAuth

final class AuthManager {
    
    private struct Constant {
        static let isSignInKey = "isSignInKey"
    }
    
    private let appleSignService: AppleSignInHelper
    private let fbCredentialService: FirebaseAuthService
    private let fireStoreService: FireStoreDBService
    
    static let shared = AuthManager()
    
    var isSignIn = CurrentValueSubject<Bool, Never>(false)
    
    private var currentUser: User?
    private(set) var user = CurrentValueSubject<UserProfile?, Never>(nil)
    
    private init(apple: AppleSignInHelper = .init(), fbCredentialService: FirebaseAuthService = .init(), fireStoreService: FireStoreDBService = .init()) {
        self.appleSignService = apple
        self.fbCredentialService = fbCredentialService
        self.fireStoreService = fireStoreService
        self.getCurrentUserSession()
    }
    
    // MARK: - SignIn & SignOut
    /// 로그인
    func signIn(with user: UserProfile) {
        print(user)
        self.isSignIn.send(true)
        self.user.send(user)
    }
    
    /// 로그아웃
    func signOut() async throws {
        do {
            try await fbCredentialService.signOut()
            self.user.send(nil)
            self.isSignIn.send(false)
        } catch {
            throw error
        }
    }
    
    /// 회원 탈퇴
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthManagerError.failToFetchUserProfile()
        }
        try await fireStoreService.deleteUserProfile(user: user)
        try await fbCredentialService.deleteAccount(user: user)
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
                self.user.send(userProfile)
                self.isSignIn.send(true)
            } catch {
                do {
                    try await fbCredentialService.signOut()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateCurrentUserProfile() {
        Task {
            let profile = try await fetchCurrentUserData()
            self.user.send(profile)
        }
    }

    /// Firebase에서 인증된 Current User 가져오기
    func fetchCurrentUserData() async throws -> UserProfile {
        do {
            guard let user = fbCredentialService.getAuthenticatedUser() else {
                throw AuthManagerError.currentUserIsNil()
            }
            
            self.currentUser = user
            let userProfile = try await fireStoreService.fetchUserProfile(user: user)
            return userProfile
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getUID() -> String? {
        let uid = self.currentUser?.uid
        return uid
    }
    
    func getMyInfoProfile() -> MyInfoProfile {
        guard getSignInState() == true, let user = user.value else {
            return MyInfoProfile(name: "로그아웃 물개", 
                                 email: "로그인 하기",
                                 imageUrl: nil)
        }
        
        return MyInfoProfile(name: user.name ?? "알 수 없는 이름", 
                             email: user.email ?? "알수없는 이메일",
                             imageUrl: user.profileImageUrl)
    }
    
    func getUserProfile() throws -> UserProfile {
        guard let user = user.value else { throw AuthManagerError.failToFetchUserProfile()}
        return user
    }
    
    enum AuthManagerError: ESError {
        
        case failToFetchUserProfile(location: String = #function)
        case currentUserIsNil(location: String = #function)
        
        var message: String {
            switch self {
            case .failToFetchUserProfile:
                return "프로필을 가져오는데 실패했습니다."
            case .currentUserIsNil:
                return "로그인 세션을 가져올 수 없습니다."
            }
        }
        
        var location: String {
            switch self {
            case .failToFetchUserProfile(let location):
                return location
            case .currentUserIsNil(let location):
                return location
            }
        }
    }
    
}

protocol ESError: Error {
    var message: String { get }
    var location: String { get }
}
