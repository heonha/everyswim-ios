//
//  MyInfoViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import Combine

final class MyInfoViewModel: BaseViewModel, CombineCancellable {
    var cancellables: Set<AnyCancellable> = .init()
    
    private let authManager: AuthManager
    
    var isSignInPublisher = AnyPublisher<Bool, Never>.init(AuthManager.shared.$isSignIn)
    @Published var myinfoProfile: MyInfoProfile? = nil
    
    init(authManager: AuthManager = .shared) {
        self.authManager = authManager
        super.init()
        observeSignInState()
    }
    
    func fetchUserProfile() {
        self.myinfoProfile = authManager.getMyInfoProfile()
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
    
    func observeSignInState() {
        authManager.$isSignIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] signIn in
                self?.fetchUserProfile()
            }
            .store(in: &cancellables)
    }
    
    func getSessionState() -> Bool {
        return authManager.isSignIn
    }
        
}
