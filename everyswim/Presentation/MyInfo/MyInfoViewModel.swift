//
//  MyInfoViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import Combine

final class MyInfoViewModel: BaseViewModel {
    
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
    
    func fetchUserProfile() {
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

    func getButtonListData() -> [MyInfoButtonType] {
        return MyInfoButtonType.allCases
    }
    
    func signOut() {
        Task(priority: .userInitiated) {
            do {
                try await authManager.signOut()
            } catch {
                print("DEBUG: 로그아웃 에러 \(error.localizedDescription)")
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
