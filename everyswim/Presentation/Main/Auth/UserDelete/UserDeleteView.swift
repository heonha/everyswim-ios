//
//  UserDeleteView.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/13/23.
//

import UIKit
import SnapKit
import Combine

final class UserDeleteView: UIView {
    
    private let viewModel: UserDeleteViewModel
    private let parentViewController: UserDeleteViewController
    private var isDeleteButtonEnable = false

    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Views
    private let titleLabel = ViewFactory
        .label("회원 탈퇴")
        .font(.custom(.sfProBold, size: 26))
        .foregroundColor(AppUIColor.label)
    
    private let emailLabel = ViewFactory
        .label("\(AuthManager.shared.getMyInfoProfile().email)")
        .font(.custom(.sfProBold, size: 16))
        .foregroundColor(AppUIColor.label)
    
    private let subtitleLabel = ViewFactory
        .label("탈퇴 시 사용자의 모든 데이터가 즉시 삭제되며 복구가 불가능합니다.")
        .font(.custom(.sfProLight, size: 16))
        .foregroundColor(AppUIColor.label)

    private let textfieldLabel = ViewFactory
        .label("탈퇴하시려면 아래에 탈퇴라고 입력 해주세요.")
        .font(.custom(.sfProLight, size: 16))
        .foregroundColor(AppUIColor.label)

    private lazy var textfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "탈퇴"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = AppUIColor.cellBackground
        return textField
    }()

    private let deleteButton = ViewFactory
        .label("탈퇴하기")
        .textAlignemnt(.center)
        .foregroundColor(AppUIColor.secondaryLabel)
        .backgroundColor(AppUIColor.cellBackground)
        .cornerRadius(4) as! UILabel

    private let backButton = ViewFactory
        .label("돌아가기")
        .textAlignemnt(.center)
        .foregroundColor(AppUIColor.label)
        .backgroundColor(.secondarySystemFill)
        .cornerRadius(4) as! UILabel
    
    // MARK: StackViews
    private lazy var titleVStack = ViewFactory.vStack()
        .addSubviews([titleLabel, subtitleLabel, emailLabel])
        .spacing(12)
        .distribution(.fillProportionally)
        .alignment(.center)
    
    private lazy var textfieldVStack = ViewFactory.vStack()
        .addSubviews([textfieldLabel, textfield])
        .spacing(8)
        .distribution(.fillProportionally)
        .alignment(.center)
    
    private lazy var buttonVStack = ViewFactory.vStack()
        .addSubviews([deleteButton, backButton])
        .spacing(8)
        .distribution(.fillEqually)
        .alignment(.center)
    
    // MARK: - Init & Lifecycle
    init(target: UserDeleteViewController, viewModel: UserDeleteViewModel) {
        self.viewModel = viewModel
        self.parentViewController = target
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    private func configure() {
        deleteButton.isUserInteractionEnabled = false
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        textfield.delegate = parentViewController
        
        observeText()
        deleteAction()
        backAction()
    }

    private func layout() {
        
        self.addSubview(titleVStack)
        self.addSubview(textfieldVStack)
        self.addSubview(buttonVStack)
        
        // titles layout
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        titleVStack.snp.makeConstraints { make in
            make.top.equalTo(self).inset(20)
            make.horizontalEdges.equalTo(self).inset(20)
        }
        
        // textfield layout
        textfieldLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        textfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(self).dividedBy(3)
        }
        
        textfieldVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        // buttons layout
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(buttonVStack)
        }
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(buttonVStack)
        }
        
        buttonVStack.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.horizontalEdges.equalTo(self).inset(40)
            make.bottom.equalTo(self).inset(40)
        }
        
    }
    
    // MARK: - Actions
    /// textfield 반환 (to ViewController)
    func getTextField() -> UITextField {
        return textfield
    }
    
    /// 계정 제거 버튼 액션
    private func deleteAction() {
        deleteButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.isDeleteButtonEnable == false { return }
                self?.requestDeleteAccount()
            }
            .store(in: &cancellables)
    }
    
    /// 유저 계정 삭제 요청.
    private func requestDeleteAccount() {
        Task(priority: .userInitiated) {
            do {
                try await self.viewModel.deleteAccount()
                self.parentViewController.pop(animated: true)
                self.parentViewController.dismiss(animated: true)
                self.presentAlert(title: "알림", message: "계정이 제거 되었습니다.")
            } catch {
                let error = error as NSError
                self.presentAlert(title: "오류", message: error.localizedFailureReason)
            }
        }
    }
    
    /// 알럿 생성 및 Present
    private func presentAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        
        self.parentViewController.present(alert, animated: true)
    }
    
    /// 뒤로가기 버튼 액션
    private func backAction() {
        backButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.parentViewController.pop(animated: true)
            }
            .store(in: &cancellables)
    }
    
    /// input 텍스트 observe
    private func observeText() {
        textfield.publisher(for: \.text)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] string in
                if string == "탈퇴" {
                    enableDeleteButton()
                } else {
                    disableDeleteButton()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - State
    /// 탈퇴하기 버튼 활성화
    private func enableDeleteButton() {
        isDeleteButtonEnable = true
        deleteButton.backgroundColor = AppUIColor.primaryBlue
        deleteButton.textColor = .white
    }
    
    /// 탈퇴하기 버튼 비활성화
    private func disableDeleteButton() {
        isDeleteButtonEnable = false
        if deleteButton.backgroundColor == AppUIColor.buttonDisableColor { return }
        deleteButton.backgroundColor = AppUIColor.cellBackground
        deleteButton.textColor = AppUIColor.secondaryLabel
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct UserDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            UserDeleteViewController()
        }
    }
}
#endif
