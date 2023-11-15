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

final class SetProfileViewController: UIViewController, CombineCancellable {
    
    private let viewModel: SetProfileViewModel
    
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
        .buttonWithText1("다음")
    
    // MARK: - StackViews
    private lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([titleView, profileImageView, textField, nextButton])
        .distribution(.equalCentering)
        .spacing(20)
    

    // MARK: - Init & LifeCycles
    
    init(viewModel: SetProfileViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNextButtonAction()
    }
    
    // MARK: - Configure
    private func configure() {
        profileImageView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                print("Image Tapped")
                presentImagePicker()
            }
            .store(in: &cancellables)
    }
    
    private func presentImagePicker() {
        let configuration = PHPickerConfiguration(photoLibrary: .shared())
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
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
    private func addNextButtonAction() {
        nextButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                print("NEXT")
                guard let text = textField.text, text.isEmpty == false else {
                    self.presentAlert(title: "알림", message: "유저명을 입력해주세요.", target: self)
                    return
                }
                print("name: \(text)")
                Task(priority: .userInitiated) {
                    do {
                        try await self.viewModel.setProfile()
                        self.navigationController?.popToRootViewController(animated: true)
                        self.presentAlert(title: "알림", message: "계정생성 완료!", target: self)
                    } catch {
                        self.presentAlert(title: "에러발생", message: "\(error.localizedDescription)", target: self)
                        return
                    }
                    
                }
                // TODO: FireStore에 데이터 저장.
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Image Picker Delegate
extension SetProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else {return}
                
        result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            guard error != nil else { return }
            
            let image = image as? UIImage
            
            DispatchQueue.main.async {
                self.profileImageView.contentView.image = image
            }
        }
    }
    
}


#if DEBUG
import SwiftUI

struct SetProfileViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SetProfileViewController()
        }
    }
}
#endif

