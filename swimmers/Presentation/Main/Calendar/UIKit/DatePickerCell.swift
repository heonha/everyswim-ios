//
//  DatePickerCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/17/23.
//


import UIKit
import SnapKit

final class DatePickerCell: UIView {
    
    private let viewModel: EventDatePickerViewModel
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
        
    
    init(viewModel: EventDatePickerViewModel, value: DateValue) {
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
        print("Layout")
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
    
    private func eventDayCell() {
        print("이벤트")

    }
    
    func setNoEvent() {
        print(#function)
        dayView.text = value.day.description
        dayView.textColor = textColor
    }
    
    func setHasEvent() {
        print(#function)
        dayView.text = value.day.description
        dayView.textColor = tintColor
    }
    
    func setEmptyCell() {
        dayView.text = ""
    }
    
    // private func makeDayCellContainer(from value: DateValue) -> UIView {
    //     let cell = eventDayCell(from: value)
    // 
    //     let vstack = ViewFactory.vStack()
    //         .addSubviews([cell])
    //         .setEdgeInset(.init(top: 0, leading: 9, bottom: 0, trailing: 9))
    // 
    //     vstack.snp.makeConstraints { make in
    //         make.height.equalTo(50)
    //     }
    //     return vstack
    // }
    // 
    // private func setHasEvent() -> UIView {
    //     let textColor = UIColor.white
    // 
    //     let circleView = UIView()
    //     circleView.backgroundColor = circleColor
    //     circleView.layer.cornerRadius = 18
    // 
    //     let dayView = ViewFactory
    //         .label(value.day.description)
    //         .font(.custom(.sfProBold, size: 16))
    //         .foregroundColor(textColor)
    //         .textAlignemnt(.center)
    // 
    //     circleView.addSubview(dayView)
    // 
    // 
    //     return circleView
    // }
    // 
}
