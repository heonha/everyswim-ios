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
    
    
    weak var parentViewController: SetProfileViewController?
    
    @Published var name: String = ""
    private var currentImage: UIImage?
    @Published var image: UIImage?
    
    init() {
        fetchCurrentProfileData()
    }
    
    private func fetchCurrentProfileData() {
        DispatchQueue.main.async {
            let userProfile = try? AuthManager.shared.getUserProfile()
            self.name = userProfile?.name ?? "알수없는 이름"
            let imageUrl = URL(string: userProfile?.profileImageUrl ?? "")
            let imageView = UIImageView()
            imageView.sd_setImage(with: imageUrl)
            self.image = imageView.image
        }
    }

    /// 최초 유저 프로필 데이터 셋업
    func setProfile(image: UIImage?) async throws {
        guard let user = firebaseAuth.getAuthenticatedUser() else {
            throw SetProfileError.dataIsNil()
        }
        
        if let imageData = image?.jpegData(compressionQuality: 0.9) {
            let urlString = try await firebaseStorage.uploadProfileImage(uid: user.uid, image: imageData)
            try await fireStore.createUserProfile(user: user, name: self.name, profileImageUrl: urlString)
        } else {
            throw SetProfileError.dataIsNil()
        }
    }
    
    /// 유저 프로필 데이터 업데이트
    func changeProfile() async throws {
        print(#function)
        do {
            guard let uid = AuthManager.shared.getUID() else {
                throw SetProfileError.uidIsNil()
            }
            
            print("\(#function) uid: \(uid)")
            
            let name = self.name
            
            var urlString: String?
            
            if currentImage?.hashValue != image.hashValue {
                print("DEBUG: 해시 값이 일치하지 않음. 이미지를 업데이트 합니다.")
                
                let imageData = image?.jpegData(compressionQuality: 0.9)
                if let imageData = imageData {
                    urlString = try await firebaseStorage.uploadProfileImage(uid: uid, image: imageData)
                } else {
                    throw SetProfileError.dataIsNil()
                }
            }
            
            print("DEBUG: 유저 프로필을 업데이트합니다.")
            try await fireStore.updateUserProfile(uid: uid, name: name, profileImageUrl: urlString)
        } catch {
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
