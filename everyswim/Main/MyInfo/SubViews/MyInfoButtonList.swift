//
//  MyInfoButtonList.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit
import Combine

final class MyInfoButtonList: BaseUIView {

    private lazy var buttons: [MyInfoButton] = getAllButtonType()
        .map { MyInfoButton($0) }
    
    private lazy var firstSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter { $0.getSection() == .first })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    private lazy var secondSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter { $0.getSection() == .second })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    private lazy var thirdSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter { $0.getSection() == .third })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    // MARK: - Init
    init() {
        super.init()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        switchVisableIconsFromSignInState(signIn: AuthManager.shared.getSignInState())
    }
    
    func switchVisableIconsFromSignInState(signIn: Bool) {
        let logoutbutton = self.getButton(.logout)
        let changeInfo = self.getButton(.changeUserInfo)
        let deleteAccount = self.getButton(.deleteAccount)
        let buttons = [logoutbutton, changeInfo, deleteAccount]
        buttons.forEach { $0.isHidden = !signIn }
        
    }
    
    // MARK: - Layout
    private func layout() {
        contentView.backgroundColor = AppUIColor.whithThickMaterialColor
        contentView.addSubview(firstSectionView)
        contentView.addSubview(secondSectionView)
        contentView.addSubview(thirdSectionView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        firstSectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.top.equalTo(contentView).inset(20)
        }
        
        secondSectionView.snp.makeConstraints { make in
            make.top.equalTo(firstSectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(12)
        }

        thirdSectionView.snp.makeConstraints { make in
            make.top.equalTo(secondSectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView).inset(20)
        }
    }
    
    enum MyInfoButtonError: Error {
        case invalidButton
    }

    private func getButton(_ buttonType: MyInfoButtonType) -> MyInfoButton {
        let button = self.buttons
            .first { return buttonType == $0.getType() }
        return button!
    }
    
    private func getAllButtonType() -> [MyInfoButtonType] {
        return MyInfoButtonType.allCases
    }
    
    // MARK: - Public
    func getButtonTapPublisher(_ type: MyInfoButtonType) -> AnyPublisher<Void, Never> {
        let targetButton = getButton(type)
        return targetButton.tapPublisher()
    }
    
    func getAllButton() -> [MyInfoButton] {
        return self.buttons
    }

}

#if DEBUG
import SwiftUI

struct MyInfoButtonList_Previews: PreviewProvider {
    
    static let parentVC = MyInfoViewController(viewModel: viewModel)
    static let viewModel = MyInfoViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            parentVC
        }
    }
}
#endif
