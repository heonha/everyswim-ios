//
//  DatePickerCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit

final class DatePickerReuseCell: UICollectionViewCell {

    static let identifier = "DatePickerCell"
    var viewModel: DatePickerViewModel!
    var content: DatePickerCell!
    
    func setDateValue(_ value: DateValue) {
        if content == nil {
            self.content = DatePickerCell(viewModel: viewModel, value: value)
            self.contentView.addSubview(content)
            content.snp.makeConstraints { make in
                make.edges.equalTo(self.contentView)
            }
            daySetter(value)
        } else {
            daySetter(value)
        }
    }
    
    private func daySetter(_ value: DateValue) {
        hiddenCircle(true)
        
        if value.day != -1 {
            content.dayView.text = value.day.description
            
            if viewModel.extractFirstEvent(date: value.date) != nil {
                updateCell(type: .hasEvent)
            } else {
                updateCell(type: .noEvent)
            }
        } else {
            updateCell(type: .empty)
        }
    }
    
    func hiddenCircle(_ isHidden: Bool) {
        content.circleView.isHidden = isHidden
    }
    
    private func updateCell(type: DatePickerEventType) {
        switch type {
        case .hasEvent:
            content.dayView.textColor = AppUIColor.whithThickMaterialColor
            content.dayView.backgroundColor = AppUIColor.primary

        case .noEvent:
            content.dayView.textColor = UIColor(hex: "000000", alpha: 0.7)
            content.dayView.backgroundColor = .white

        case .empty:
            content.dayView.text = ""
            content.dayView.backgroundColor = .white
        }
    }
    
}

enum DatePickerEventType {
    case hasEvent
    case noEvent
    case empty
}
