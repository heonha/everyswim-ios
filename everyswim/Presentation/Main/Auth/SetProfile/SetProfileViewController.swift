//
//  SetProfileViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/15/23.
//
import UIKit
import SnapKit
import Combine
import PhotosUI

enum SetProfileViewControllerType {
    case signUp
    case changeProfile
}

final class SetProfileViewController: BaseViewController, CombineCancellable {
    
    private let viewModel: SetProfileViewModel
    private let type: SetProfileViewControllerType
    
    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Views
    private let titleView = MidTitleVStack(title: "프로필 설정",
                                           subtitle: "나의 프로필 사진과 이름을 입력하세요")
        
    private let profileImageView = BaseImageView(size: .init(width: 120, height: 120)) {
        UIImageView()
            .setImage(AppImage.defaultUserProfileImage.getImage())
            .contentMode(.scaleAspectFill)
            .cornerRadius(60)
            .backgroundColor(AppUIColor.skyBackground)
    }
    
    private let textField = BaseTextField()
        .placeholder("앱에서 사용할 이름을 입력하세요.")
        .font(.custom(.sfProMedium, size: 18))
        .backgroundColor(AppUIColor.skyBackground) as! UITextField
    
    private let nextButton = ViewFactory
        .buttonWithText1("완료")
    
    // MARK: - StackViews
    private lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([titleView, profileImageView, textField, nextButton])
        .distribution(.equalCentering)
        .spacing(20)
    

    // MARK: - Init & LifeCycles
    
    init(viewModel: SetProfileViewModel, type: SetProfileViewControllerType) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
        setCurrentProfile()
    }
    
    // MARK: - Configure
    private func configure() {
        view.backgroundColor = .systemBackground
        profileButtonTapgesture()
        addNextButtonAction()
        configureTextField()
    }
    
    private func setCurrentProfile() {
        if type == .changeProfile {
            textField.text = self.viewModel.name
            setProfileImage(image: viewModel.image ?? AppImage.defaultUserProfileImage.getImage())
        }
    }
    
    private func presentImagePicker() {
        let configuration = PHPickerConfiguration(photoLibrary: .shared())
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    private func configureTextField() {
        textField.delegate = self
        textfieldHideKeyboardGesture()
    }
    
    private func layout() {
        view.addSubview(mainVStack)
        mainVStack.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.horizontalEdges.equalTo(view).inset(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
     
        textField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
    }
    
    // MARK: - Actions
    
    private func profileButtonTapgesture() {
        profileImageView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                print("Image Tapped")
                presentImagePicker()
            }
            .store(in: &cancellables)
    }
    
    func setProfileImage(image: UIImage) {
        self.profileImageView.contentView.image = image
    }
    
    func getProfileImage() -> UIImage? {
        return self.profileImageView.contentView.image
    }
    
    private func addNextButtonAction() {
        nextButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}

                guard let text = textField.text, text.isEmpty == false else {
                    self.presentAlert(title: "알림", message: "유저이름을 입력해주세요.", target: self)
                    return
                }
                print("name: \(text)")
                
                Task(priority: .userInitiated) {
                    do {
                        switch self.type {
                        case .signUp:
                            try await self.viewModel.setProfile(name: self.textField.text ?? "")
                            DispatchQueue.main.async {
                                let action = UIAlertAction(title: "확인", style: .default) { _ in
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                self.presentAlert(title: "알림", message: "프로필 설정 완료", target: self, action: [action])
                            }
                        case .changeProfile:
                            try await self.viewModel.changeProfile(name: self.textField.text ?? "")
                            DispatchQueue.main.async {
                                let action = UIAlertAction(title: "확인", style: .default) { _ in
                                    self.dismiss(animated: true)
                                }
                                self.presentAlert(title: "알림", message: "프로필 변경 완료", target: self, action: [action])
                            }
                        }
                    } catch {
                        
                        if let error = error as? ESError {
                            self.presentAlert(title: "에러발생",
                                              message: "\(error.message)",
                                              target: self)
                            return
                        }

                        self.presentAlert(title: "에러발생",
                                          message: "\(error.localizedDescription)",
                                          target: self)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - TextField Delegate
extension SetProfileViewController: UITextFieldDelegate {
    // func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //     textField.resignFirstResponder()
    //     return true
    // }
}

// MARK: - Image Picker Delegate
extension SetProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        viewModel.parentViewController = self
        viewModel.setSelectedImage(picker: picker, results: results)
    }
    
}

enum SetProfileError: ESError {
    
    case uidIsNil(location: String = #function)
    case dataIsNil(location: String = #function)
    
    var message: String {
        switch self {
        case .uidIsNil:
            return "uid가 없습니다. \(location)"
        case .dataIsNil:
            return "data가 없습니다. \(location)"
        }
    }
    
    var location: String {
        switch self {
        case .uidIsNil(let location):
            return location
        case .dataIsNil(let location):
            return location
        }
    }

}


// MARK: - Preview
#if DEBUG
import SwiftUI

struct SetProfileViewController_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetProfileViewModel()
        let viewController = SetProfileViewController(viewModel: viewModel, type: .changeProfile)

        UIViewControllerPreview {
            viewController
        }
    }
}
#endif
