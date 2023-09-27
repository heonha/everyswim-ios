//
//  EmptySwimRecordSmallCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/27/23.
//

import UIKit
import SnapKit

final class EmptySwimSmallCell: UITableViewCell {
    
    private var titleLabel = ViewFactory.label()
        .textAlignemnt(.center)
        .font(.custom(.sfProLight, size: 18))
        .foregroundColor(AppUIColor.grayTint)
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        self.isUserInteractionEnabled = false
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    private func layout() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(Constant.deviceSize.width)
        }
    }
    
    static func withType(_ type: EmptySwimSmallCellType) -> EmptySwimSmallCell {
        let cell = EmptySwimSmallCell()
        switch type {
        case .daily:
            cell.titleLabel.text = "이 날의 운동 기록이 없습니다."
        case .monthly:
            cell.titleLabel.text = "이 달의 운동 기록이 없습니다."
        }
        return cell
    }
    
}

enum EmptySwimSmallCellType {
    case daily
    case monthly
}

