//
//  BaseViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/19/23.
//

import UIKit
import SnapKit
import Combine

class BaseViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    private let messageView = MessageView()

    init(backgroundColor: UIColor = .systemBackground) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// TextField 사용 시 키보드 외 터치시 키보드를 내리도록 함.
    func assignTextfieldHideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldHideKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .systemBackground
    }
    
    @objc func textFieldHideKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlert(title: String?, message: String?, target: UIViewController, action: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        if let alertAction = action {
            alertAction.forEach { action in
                print("액션을 셋업합니다.")
                alert.addAction(action)
            }
        } else {
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
        }
        target.present(alert, animated: true)
    }
    
    private func setupMessage() {
        view.addSubview(messageView)
        messageView.snp.remakeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).inset(100)
            make.height.greaterThanOrEqualTo(40)
            make.width.equalTo(view).dividedBy(1.3)
        }
    }
    
    /// 하단에 메시지를 띄웁니다.
    public func presentMessage(title: String) {
        let isContainView = view.subviews.contains(where: { view in
            view === self.messageView
        })
        
        if !isContainView {
            setupMessage()
        }
        
        messageView.present(title: title)
    }
  
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct BaseViewController_Previews: PreviewProvider {
    
    static let viewController = BaseViewController()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            viewController.presentMessage(title: "hi\n헬로우안녕\n세줄")
        })
    }
}
#endif
