//
//  ActivitySummaryView.swift
//  everyswim
//
//  Created by HeonJin Ha on 1/14/24.
//

import UIKit
import SnapKit

final class ActivitySummaryView: BaseUIView {
    
    private let titleLabel = ViewFactory
        .label("이번 주")
        .font(.custom(.sfProBold, size: 17))
        .foregroundColor(.secondaryLabel)

    private let titleLabelSybmol = UIImageView()
        .setSymbolImage(systemName: "chevron.down", color: AppUIColor.grayTint)
        .contentMode(.scaleAspectFit)
        .setSize(width: 20, height: 20)

    private lazy var distanceLabel = DistanceLargeLabel()
    private lazy var recordHStackView = ActivityDetailCenterDataView()
    public lazy var titleMenu = ViewFactory
        .hStack()
        .addSubviews([titleLabel, titleLabelSybmol])
        .spacing(4)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    private lazy var recordMainStack = ViewFactory.vStack()
       .addSubviews([titleMenu, distanceLabel, recordHStackView])
       .spacing(30)
       .alignment(.center)
       .distribution(.fillProportionally)
    
    init() {
        super.init()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        self.addSubview(titleMenu)
        self.addSubview(distanceLabel)
        self.addSubview(recordHStackView)
        
        titleMenu.snp.makeConstraints { make in
            make.top.equalTo(self).inset(16)
            make.height.equalTo(44)
            make.centerX.equalTo(self)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleMenu.snp.bottom).offset(16)
            make.height.equalTo(100)
            make.centerX.equalTo(self)
        }
        
        recordHStackView.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(24)
            make.width.equalTo(self).inset(30)
            make.centerX.equalTo(self)
            make.height.equalTo(70)
        }
    }
    
    func setData(_ data: SwimSummaryViewModel) {
        distanceLabel.setData(data.distance, unit: data.distanceUnit)
        recordHStackView.setData(data)
    }
    
}

// MARK: - Previewer
#if DEBUG
import SwiftUI

struct ActivitySummaryView_Previews: PreviewProvider {
    
    static let viewController = ActivityViewController(viewModel: viewModel)
    static let viewModel = ActivityViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
