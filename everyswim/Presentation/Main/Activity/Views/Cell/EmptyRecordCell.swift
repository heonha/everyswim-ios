//
//  EmptySwimRecordSmallCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/27/23.
//

import UIKit
import SnapKit

final class EmptyRecordCell: UITableViewCell {
    
    private var titleLabel = ViewFactory
        .label()
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
            make.width.equalTo(AppConstant.deviceSize.width)
        }
    }
    
    static func withType(_ type: EmptySwimSmallCellType) -> EmptyRecordCell {
        let cell = EmptyRecordCell()
        cell.titleLabel.numberOfLines = 0

        switch type {
        case .daily:
            cell.titleLabel.text = "이 날의 수영 기록이 없습니다."
        case .monthly:
            cell.titleLabel.text = "이 달의 수영 기록이 없습니다."
        case .normal:
            cell.titleLabel.text = "수영 기록이 없습니다."
        }
        return cell
    }
    
}

enum EmptySwimSmallCellType {
    case daily
    case monthly
    case normal
}

