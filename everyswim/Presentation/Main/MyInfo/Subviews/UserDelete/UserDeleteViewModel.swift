//
//  UserDeleteViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/13/23.
//

import Foundation
import FirebaseAuth

final class UserDeleteViewModel: ObservableObject {
    
    private let firebaseService: FirebaseAuthService
    private let fireStoreService: FireStoreService
    
    init(firebase: FirebaseAuthService = .init(), firestore: FireStoreService = .init()) {
        self.firebaseService = firebase
        self.fireStoreService = firestore
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw FireStoreServiceError.currentUserIsNil
        }
        try await fireStoreService.deleteUserProfile(user: user)
        try await firebaseService.deleteAccount(user: user)
    }
    
}
