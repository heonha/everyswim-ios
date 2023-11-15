//
//  SetProfileViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/15/23.
//

import UIKit

final class SetProfileViewModel: ObservableObject {
    
    private let fireStore = FireStoreService()
    private let firebaseAuth = FirebaseAuthService()
    
    @Published var name: String = ""
    @Published var image: UIImage = UIImage()
    
    func setProfile() async throws {
        let user = try firebaseAuth.getAuthenticatedUser()
        // TODO: Storage에 이미지 올리고 URL 받기
        let urlString = ""
        try await fireStore.createUserProfile(user: user, name: self.name, profileImageUrl: urlString)
    }
    
}
