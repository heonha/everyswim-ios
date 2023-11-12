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
        if authManager.isSignIn {
            self.myinfoProfile = authManager.getMyInfoProfile()
            print("\(#function) 세션 myInfo PRofile을 셋업합니다.")
        } else {
            self.myinfoProfile = authManager.getGuestProfile()
            print("\(#function) 세션 비로그인 상태입니다.")
        }
    }

    func getButtonListData() -> [MyInfoButtonType] {
        return MyInfoButtonType.allCases
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            self.getGuestProfile()
        } catch {
            print("DEBUG: 로그아웃 에러 \(error.localizedDescription)")
        }
    }
    
    func getGuestProfile() {
        let guestProfile = authManager.getGuestProfile()
        self.myinfoProfile = guestProfile
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
