//
//  UserDeleteViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/13/23.
//

import Foundation
import FirebaseAuth

final class UserDeleteViewModel: BaseViewModel {

    private let authManager: AuthManager
    
    init(authManager: AuthManager = .shared) {
        self.authManager = authManager
        super.init()
    }
    
    func deleteAccount() async throws {
        try await authManager.deleteUser()
        try await authManager.signOut()
    }
    
}
