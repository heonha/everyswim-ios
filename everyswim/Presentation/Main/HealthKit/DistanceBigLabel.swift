//
//  DistanceBigLabel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import Foundation

import UIKit
import SnapKit

final class DistanceBigLabel: UIView {
    
    // 몇 미터
    private lazy var distanceLabel = ViewFactory
        .label("--")
        .font(.custom(.sfProBold, size: 70))
        .foregroundColor(AppUIColor.label)
    
    private lazy var distanceUnitLabel = ViewFactory
        .label("m")
        .font(.custom(.sfProMedium, size: 28))
        .foregroundColor(.secondaryLabel)
    
    private lazy var distanceStack = ViewFactory
        .hStack()
        .addSubviews([distanceLabel, distanceUnitLabel])
        .alignment(.bottom)
        .distribution(.fillProportionally)
        .spacing(8)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        addSubview(distanceStack)
        distanceStack.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.height.equalTo(88)
        }
    }
    
    func setData(_ data: String?, unit: String) {
        distanceLabel.text = data
        distanceUnitLabel.text = unit
    }
    
}
