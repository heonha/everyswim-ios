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
    
    private lazy var vstack = ViewFactory
        .vStack()
        .addSubviews(buttons)
        .spacing(12)
        .alignment(.fill)
        .distribution(.equalCentering)
    
    init(viewModel: MyInfoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subview()
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        self.addSubview(background)
        background.addSubview(vstack)
        background.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
    private func subview() {
        vstack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(background).inset(12)
            make.verticalEdges.equalTo(background).inset(20)
        }
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

