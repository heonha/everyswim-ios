//
//  SetProfileViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/15/23.
//

import UIKit
import PhotosUI

final class SetProfileViewModel: ObservableObject {
    
    private let fireStore = FireStoreDBService()
    private let firebaseAuth = FirebaseAuthService()
    private let firebaseStorage = FirebaseStorageService()
    
    private let authManager = AuthManager.shared
    weak var parentViewController: SetProfileViewController?
    
    private var currentImage: UIImage?

    @Published var name: String = ""
    @Published var image: UIImage?
    @Published var isLoading: Bool = true
    
    init() {
        updateProfileData()
    }
    
    func updateProfileData() {
        let profile = authManager.getMyInfoProfile()
            fetchCurrentProfileData(profile: profile)
    }
    
    private func fetchCurrentProfileData(profile: MyInfoProfile) {
        
        DispatchQueue.main.async {
            self.name = profile.name
            let imageUrl = URL(string: profile.imageUrl ?? "")
            let imageView = UIImageView()
            imageView.sd_setImage(with: imageUrl)
            self.image = imageView.image
            self.currentImage = imageView.image
            self.isLoading = false
        }
    }

    /// 최초 유저 프로필 데이터 셋업
    func setProfile(name: String) async throws {
        guard let user = firebaseAuth.getAuthenticatedUser() else {
            throw SetProfileError.dataIsNil()
        }
        
        if let imageData = image?.jpegData(compressionQuality: 0.9) {
            let urlString = try await firebaseStorage.uploadProfileImage(uid: user.uid, image: imageData)
            try await fireStore.createUserProfile(user: user, name: name, profileImageUrl: urlString)
        } else {
            throw SetProfileError.dataIsNil()
        }
    }
    
    private func updateImage(image: UIImage?) {
        
    }
    
    /// 유저 프로필 데이터 업데이트
    func changeProfile(name: String) async throws {
        print(#function)
        self.isLoading = true
        do {
            guard let uid = AuthManager.shared.getUID() else {
                throw SetProfileError.uidIsNil()
            }
            
            var urlString: String?
            
            if let currentHash = currentImage?.hashValue {
                let selectedImageHash = image.unsafelyUnwrapped.hash
                if currentHash != selectedImageHash {
                    print("DEBUG: 해시 값이 일치하지 않음. 이미지를 업데이트 합니다.")
                    let imageData = image?.jpegData(compressionQuality: 0.9)
                    if let imageData = imageData {
                        urlString = try await firebaseStorage.uploadProfileImage(uid: uid, image: imageData)
                    } else {
                        throw SetProfileError.dataIsNil()
                    }
                } else {
                    print("DEBUG: 이미지 해시값이 일치함. 이미지 업데이트가 필요없습니다.")
                }
            } else {
                print("DEBUG: 해시 값이 없음. 이미지를 업데이트 합니다.")
                let imageData = image?.jpegData(compressionQuality: 0.9)
                if let imageData = imageData {
                    urlString = try await firebaseStorage.uploadProfileImage(uid: uid, image: imageData)
                } else {
                    throw SetProfileError.dataIsNil()
                }
            }

            print("DEBUG: 유저 프로필을 업데이트합니다.")
            try await fireStore.updateUserProfile(uid: uid, name: name, profileImageUrl: urlString)
            self.authManager.updateCurrentUserProfile()
            self.isLoading = false
        } catch {
            self.isLoading = false
            throw error
        }
    }
    
    func setSelectedImage(picker: PHPickerViewController, results: [PHPickerResult]) {
        
        guard let parentViewController = parentViewController else { return }
        
        if let result = results.first?.itemProvider {
            result.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {  
                    if let error = error {
                        parentViewController.presentAlert(title: "ERROR", message: error.localizedDescription, target: parentViewController)
                        return
                    }
                    
                    guard let image = image as? UIImage else { return }
                    self.image = image

                    parentViewController.setProfileImage(image: image)
                }
            }
        } else {
            parentViewController.presentAlert(title: "ERROR", message: "image is nil", target: parentViewController)
        }
        picker.dismiss(animated: true)
    }
    
}
