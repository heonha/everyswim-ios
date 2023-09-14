//
//  DatePickerCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit

final class DatePickerCell: UICollectionViewCell {

    var viewModel: EventDatePickerViewModel
    
    init(viewModel: EventDatePickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func eventDayCellHandler(from value: DateValue) -> UIView {
        
        if value.day != -1 {
            if viewModel.extractFirstEvent(date: value.date) != nil {
                return self.makeEventDayCell(value)
            } else {
                return self.makeNoEventDayCell(value)
            }
        } else {
            return UIView()
        }
    }
    
    private func makeDayCellContainer(from value: DateValue) -> UIView {
        
        let cell = eventDayCellHandler(from: value)
    
        let vstack = ViewFactory.vStack()
            .addSubviews([cell])
            .setEdgeInset(.init(top: 0, leading: 9, bottom: 0, trailing: 9))
        
        vstack.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return vstack
    }
    
    private func makeNoEventDayCell(_ value: DateValue) -> UIView {
        let textColor = viewModel.isSameDay(value.date, viewModel.currentDate)
        ? UIColor.black
        : UIColor.tintColor

        let baseView = UIView()
        baseView.backgroundColor = .white
        
        let dayView = ViewFactory
            .label(value.day.description)
            .font(.custom(.sfProBold, size: 16))
            .foregroundColor(textColor)

        baseView.addSubview(dayView)
        
        baseView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        
        dayView.snp.makeConstraints { make in
            make.size.equalTo(baseView)
        }
        
        return baseView
    }
    
    private func makeEventDayCell(_ value: DateValue) -> UIView {
        let textColor = UIColor.white
        let circleColor = tintColor
        
        let circleView = UIView()
        circleView.backgroundColor = circleColor
        circleView.layer.cornerRadius = 18
        
        
        let dayView = ViewFactory
            .label(value.day.description)
            .font(.custom(.sfProBold, size: 16))
            .foregroundColor(textColor)

        circleView.addSubview(dayView)
        
        circleView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        
        dayView.snp.makeConstraints { make in
            make.size.equalTo(circleView)
        }
        
        return circleView
    }

    
}
