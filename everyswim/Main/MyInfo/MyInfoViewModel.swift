//
//  MyInfoViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import Combine

final class MyInfoViewModel: BaseViewModel, IOProtocol {

    struct Input {
        let signOutTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let profileUpdatePublisher: AnyPublisher<Bool, Never>
        let logoutPublisher: AnyPublisher<Void, Never>
    }
    
    private let authManager: AuthManager
    
    var isSignInPublisher: AnyPublisher<Bool, Never> {
        return AuthManager.shared.isSignIn.eraseToAnyPublisher()
    }
    
    var lastHealthUpdateDate: AnyPublisher<String?, Never> {
        return SwimDataStore.shared.lastUpdatedDate
            .map { $0?.toString(.timeWithoutSeconds) }
            .eraseToAnyPublisher()
    }
    
    private(set) var myinfoProfile = CurrentValueSubject<MyInfoProfile?, Never>(nil)
    
    init(authManager: AuthManager = .shared) {
        self.authManager = authManager
        super.init()
        observeSignInState()
        observeUserProfile()
    }
    
    func transform(input: Input) -> Output {
        
        let logoutPublisher = input.signOutTapPublisher
            .map {
                self.signOut()
                return $0
            }
            .eraseToAnyPublisher()
        
        let profileUpdatePublisher = Publishers
            .CombineLatest(AuthManager.shared.isSignIn, authManager.user.eraseToAnyPublisher())
            .filter { $0 == true || $1 != nil }
            .map { isSignIn, _ -> Bool in
                if isSignIn { self.fetchUserProfile() }
                return isSignIn
            }
            .eraseToAnyPublisher()
        
        return Output(profileUpdatePublisher: profileUpdatePublisher,
                      logoutPublisher: logoutPublisher)
    }
    
    private func fetchUserProfile() {
        let profile = authManager.getMyInfoProfile()
        self.myinfoProfile.send(profile)
    }
    
    private func observeUserProfile() {
        authManager.user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchUserProfile()
            }
            .store(in: &cancellables)
    }

    func getAllButtonType() -> [MyInfoButtonType] {
        return MyInfoButtonType.allCases
    }
    
    func signOut() {
        Task(priority: .userInitiated) {
            do {
                try await authManager.signOut()
            } catch {
                print("DEBUG: 로그아웃 에러 \(error.localizedDescription)")
                self.sendMessage(message: "\(error)")
            }
        }
    }
    
    private func observeSignInState() {
        authManager.isSignIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchUserProfile()
            }
            .store(in: &cancellables)
    }
    
    func getSessionState() -> Bool {
        return authManager.isSignIn.value
    }
        
}
