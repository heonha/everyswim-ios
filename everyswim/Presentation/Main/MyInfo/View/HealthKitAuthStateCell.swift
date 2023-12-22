//
//  HealthKitAuthStateCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/16/23.
//

import UIKit
import SnapKit

final class HealthKitAuthStateCell: UIView {
    
    private let contentView = UIView()
        .backgroundColor(.systemBackground)
        .shadow(color: .black, alpha: 0.2, x: 0.3, y: 0.3, blur: 1, spread: 0, radius: 0.3)
        .cornerRadius(8)
    
    private let healthImageView = UIImageView()
        .setImage(AppImage.appleHealth.getImage())
    
    private let titleLabel = ViewFactory
        .label("건강 데이터")
        .font(.custom(.sfProBold, size: 15))
    
    private let stateLabel = ViewFactory
        .label("업데이트 시간")
        .font(.custom(.sfProMedium, size: 14))
        .foregroundColor(.init(hex: "000000", alpha: 0.4))
    
    private let updatedTimeLabel = ViewFactory
        .label("12:30")
        .font(.custom(.sfProMedium, size: 14))
        .foregroundColor(.init(hex: "000000", alpha: 0.4))
    
    private lazy var updateStateView = ViewFactory.hStack()
        .addSubviews([stateLabel, updatedTimeLabel])
    
    private lazy var titleViews = ViewFactory
        .vStack()
        .addSubviews([titleLabel, updateStateView])
        .alignment(.leading)
    
    private let refreshImageView = UIImageView()
        .setSymbolImage(systemName: "arrow.clockwise.circle.fill",
                        color: .init(hex: "000000", alpha: 0.4))

    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(contentView)
        self.backgroundColor = .systemBackground
        contentView.addSubview(healthImageView)
        contentView.addSubview(titleViews)
        contentView.addSubview(refreshImageView)
    }
    
    private func layout() {
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview()
        }
        
        healthImageView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(8)
        }
        
        titleViews.snp.makeConstraints { make in
            make.leading.equalTo(healthImageView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(refreshImageView.snp.leading).inset(10)
        }
        
        refreshImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(20)
            make.centerY.equalTo(contentView)
        }
    }
    
    func getRefreshButton() -> UIView {
        return self.refreshImageView
    }
    
}

#if DEBUG
import SwiftUI

struct HealthKitAuthStateCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            HealthKitAuthStateCell()
        }
        .frame(height: 90)
    }
}
#endif
