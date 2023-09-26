//
//  MyInfoButtonList.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/14/23.
//

import UIKit
import SnapKit

final class MyInfoButtonList: UIView {
    
    private let viewModel: MyInfoViewModel
    
    private let background = UIView()
        .backgroundColor(AppUIColor.whithThickMaterialColor)
        .cornerRadius(12)
    
    private lazy var buttons: [MyInfoButton] = viewModel
        .getButtonListData()
        .map { MyInfoButton($0) }
    
    private lazy var firstSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter{ $0.getSection() == .first })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    private lazy var secondSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter{ $0.getSection() == .second })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    private lazy var thirdSectionView = ViewFactory
        .vStack()
        .addSubviews(buttons.filter{ $0.getSection() == .third })
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    init(viewModel: MyInfoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subview()
    }
    
    private func layout() {
        self.addSubview(background)
        background.addSubview(firstSectionView)
        background.addSubview(secondSectionView)
        background.addSubview(thirdSectionView)

        background.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func subview() {
        firstSectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(background).inset(12)
            make.top.equalTo(background).inset(20)
        }
        
        secondSectionView.snp.makeConstraints { make in
            make.top.equalTo(firstSectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(background).inset(12)
        }

        thirdSectionView.snp.makeConstraints { make in
            make.top.equalTo(secondSectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(background).inset(12)
            make.bottom.equalTo(background).inset(20)
        }

    }
    
    func getButton(type: MyInfoButtonType) -> MyInfoButton {
        let button = self.buttons.first { infoButton in
            return type == infoButton.getType()
        }
        
        if let button = button {
            return button
        } else {
            return MyInfoButton(.setupAlert)
        }
    }
    
    func getAllButton() -> [MyInfoButton] {
        return self.buttons
    }
    
    
}

#if DEBUG
import SwiftUI

struct MyInfoButtonList_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            MyInfoButtonList(viewModel: MyInfoViewModel())
        }
    }
}
#endif
