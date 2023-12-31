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
        let tappedLogout: AnyPublisher<Void, Never>
        let excuteLogout: AnyPublisher<Void, Never>
        let tappedHealthRefreshButton: AnyPublisher<Void, Never>
        let tappedSearchPoolButtonTapPublisher: AnyPublisher<Void, Never>
        let tappedEditChallangeButtonPublisher: AnyPublisher<Void, Never>
        let tappedChangeUserInfoButtonPublisher: AnyPublisher<Void, Never>
        let tappedDeleteAccountButtonPublisher: AnyPublisher<Void, Never>
        let tappedNotValiableMessageButtonPublisher: AnyPublisher<Void, Never>

    }
    
    struct Output {
        let profileUpdated: AnyPublisher<MyInfoProfile, Never>
        let logoutSuccessed: AnyPublisher<Void, Never>
        let presentLogoutAlert: AnyPublisher<Void, Never>
        let healthDataUpdated: AnyPublisher<String, Never>
        let presentHealthDataUpdateAlert: AnyPublisher<Void, Never>
        let pushSearchSwimPoolViewController: AnyPublisher<Void, Never>
        let presentEditChallangeView: AnyPublisher<Void, Never>
        let presentChangeUserInfoView: AnyPublisher<Void, Never>
        let pushDeleteAccountView: AnyPublisher<Void, Never>
        let presentNotValiableMessage: AnyPublisher<Void, Never>
        let updateSignState: AnyPublisher<Bool, Never>
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
    
    // private(set) var myinfoProfile = CurrentValueSubject<MyInfoProfile?, Never>(nil)
    
    init(authManager: AuthManager = .shared) {
        self.authManager = authManager
        super.init()
        // observeSignInState()
        // observeUserProfile()
    }
    
    // swiftlint:disable:next function_body_length
    func transform(input: Input) -> Output {
        
        // MARK: - Auth State Output
        /// 로그 아웃을 진행함 (input: 로그아웃 버튼 탭)
        let logoutSuccessed = input.tappedLogout
            .map {
                self.signOut()
                return $0
            }
            .eraseToAnyPublisher()
        
        /// 로그인 상태를 리턴 함. (로그인 상태일 경우 유저 데이터를 업데이트)
        let profileUpdated = Publishers
            .CombineLatest(AuthManager.shared.isSignIn, authManager.user.eraseToAnyPublisher())
            .filter { $0 == true || $1 != nil }
            .compactMap { [weak self] isSignIn, _ in
                self?.authManager.getMyInfoProfile()
            }
            .eraseToAnyPublisher()
        
        let updateSignState = AuthManager.shared.isSignIn
            .eraseToAnyPublisher()
        
        // MARK: - HealthData Update Output
        /// Swim Data 가져오기 완료시간을 리턴.
        let healthDataUpdated =  Publishers
            .CombineLatest(input.tappedHealthRefreshButton,
                           SwimDataStore.shared.lastUpdatedDate)
            .subscribe(on: DispatchQueue.global())
            .map { _, date -> String in
                if let date = date {
                    return date.toString(.timeWithoutSeconds)
                } else {
                    return "동기화 실패"
                }
            }
            .eraseToAnyPublisher()
        
        /// Swim Data 가져오기를 실행하고, ViewController에 시작되었음을 알림.
        let presentHealthDataUpdateAlert = input.tappedHealthRefreshButton
            .map {
                SwimDataStore.shared.refreshSwimData()
                return $0
            }
            .eraseToAnyPublisher()
        
        // MARK: - Push & Present Output
        let pushSearchSwimPoolViewController = input
            .tappedSearchPoolButtonTapPublisher
            .eraseToAnyPublisher()

        let presentEditChallangeView = input
            .tappedEditChallangeButtonPublisher
            .eraseToAnyPublisher()

        let presentChangeUserInfoView = input
            .tappedChangeUserInfoButtonPublisher
            .eraseToAnyPublisher()

        let pushDeleteAccountView = input
            .tappedDeleteAccountButtonPublisher
            .eraseToAnyPublisher()

        let presentNotValiableMessage = input
            .tappedNotValiableMessageButtonPublisher
            .eraseToAnyPublisher()
        
        let presentLogoutAlert = input.tappedLogout
            .eraseToAnyPublisher()
        
        input.excuteLogout
            .sink { [weak self] _ in
                self?.signOut()
            }
            .store(in: &cancellables)

        return Output(profileUpdated: profileUpdated, 
                      logoutSuccessed: logoutSuccessed,
                      presentLogoutAlert: presentLogoutAlert,
                      healthDataUpdated: healthDataUpdated,
                      presentHealthDataUpdateAlert: presentHealthDataUpdateAlert,
                      pushSearchSwimPoolViewController: pushSearchSwimPoolViewController,
                      presentEditChallangeView: presentEditChallangeView,
                      presentChangeUserInfoView: presentChangeUserInfoView,
                      pushDeleteAccountView: pushDeleteAccountView,
                      presentNotValiableMessage: presentNotValiableMessage,
                      updateSignState: updateSignState
        )
    }
    // 
    // private func observeUserProfile() {
    //     authManager.user
    //         .receive(on: DispatchQueue.main)
    //         .sink { [weak self] _ in
    //             self?.fetchUserProfile()
    //         }
    //         .store(in: &cancellables)
    // }
    
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
    // 
    // private func observeSignInState() {
    //     authManager.isSignIn
    //         .receive(on: DispatchQueue.main)
    //         .sink { [weak self] _ in
    //             self?.fetchUserProfile()
    //         }
    //         .store(in: &cancellables)
    // }
    
    func getSessionState() -> Bool {
        return authManager.isSignIn.value
    }
        
}
