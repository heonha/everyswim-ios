//
//  DatePickerCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//


import UIKit
import SnapKit

final class DatePickerCell: UIView {
    
    private let viewModel: DatePickerViewModel
    var value: DateValue

    lazy var textColor = viewModel.isSameDay(value.date, viewModel.currentDate)
    ? UIColor.black
    : UIColor.tintColor
    
    var circleInset: CGFloat = 8
    var dayViewInset: CGFloat = 10
    let circleColor = AppUIColor.primary

    private let baseView = UIView()
        .backgroundColor(.clear)
    
    lazy var dayView = ViewFactory
        .label(value.day.description)
        .font(.custom(.sfProBold, size: 16))
        .foregroundColor(textColor)
        .textAlignemnt(.center)
        .cornerRadius((viewModel.getCellSize().width - (dayViewInset * 2)) / 2) as! UILabel
    
    lazy var circleView = UIView()
        .backgroundColor(.white)
        .cornerRadius((viewModel.getCellSize().width - (circleInset * 2)) / 2)
        .shadow(color: .black, x: 0, y: 0)
        
    
    init(viewModel: DatePickerViewModel, value: DateValue) {
        self.viewModel = viewModel
        self.value = value
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func layout() {
        self.addSubview(baseView)
        baseView.addSubview(circleView)
        baseView.addSubview(dayView)
        circleView.isHidden = true
    
        baseView.snp.makeConstraints { make in
            make.size.equalTo(viewModel.getCellSize())
        }
    
        dayView.snp.makeConstraints { make in
            make.size.equalTo(baseView).inset(dayViewInset)
            make.center.equalTo(baseView)
        }
        
        circleView.snp.makeConstraints { make in
            make.size.equalTo(baseView).inset(circleInset)
            make.center.equalTo(baseView)
        }
        
    }
    
}
