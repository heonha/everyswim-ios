//
//  UserDeleteViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/13/23.
//

import UIKit
import SnapKit
import Combine

final class UserDeleteViewController: BaseViewController {
    
    private let viewModel: UserDeleteViewModel
    
    private lazy var userDeleteView = UserDeleteView(target: self, viewModel: viewModel)
    
    init(viewModel: UserDeleteViewModel = .init()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func layout() {
        view.addSubview(userDeleteView)
        userDeleteView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension UserDeleteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
