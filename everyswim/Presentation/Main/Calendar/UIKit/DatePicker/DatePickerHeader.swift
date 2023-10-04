//
//  WorkoutDatePickerHeader.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit

final class DatePickerHeader: UIView {
    
    private let viewModel: DatePickerViewModel
    
    private lazy var month = ViewFactory
        .label(viewModel.extraDate()[1])
        .font(.custom(.sfProBold, size: 22))
    
    private lazy var year = ViewFactory
        .label(viewModel.extraDate()[0])
        .font(.custom(.sfProLight, size: 16))

    private lazy var dateView: UIView = {
        let hstack = ViewFactory
            .hStack()
            .addSubviews([month, year])
            .alignment(.bottom)
            .distribution(.fillProportionally)
            .spacing(10)
            .setEdgeInset(.init(top: 0, leading: 6, bottom: 0, trailing: 6))

        return hstack
    }()
    
    
    private lazy var monthChangeButtonsView: UIView = {
        
        let before = UIButton()
        before.addTarget(self.next, action: #selector(beforeMonth), for: .touchUpInside)
        let leftChevron = UIImage(systemName: "chevron.left")?
            .withTintColor(AppUIColor.grayTint, renderingMode: .alwaysOriginal)
        before.setImage(leftChevron, for: .normal)
        
        let forward = UIButton()
        forward.addTarget(self.next, action: #selector(forewardMonth), for: .touchUpInside)
        let rightChevron = UIImage(systemName: "chevron.right")?
            .withTintColor(AppUIColor.grayTint, renderingMode: .alwaysOriginal)
        forward.setImage(rightChevron, for: .normal)
        
        let hstack = ViewFactory
            .hStack()
            .addSubviews([before, forward])
            .spacing(20)
            .setEdgeInset(.init(top: 0, leading: 0, bottom: 0, trailing: 6))
        
        return hstack
    }()
    
    private lazy var weekdaysView: UIView = {
        let weekdays = Weekdays.values
            .map { weekday -> UILabel in
                let label = ViewFactory.label(weekday)
                    .font(.custom(.sfProBold, size: 14))
                    .foregroundColor(AppUIColor.grayTint)
                    .textAlignemnt(.center)
                
                return label
            }
        
        let hstack = ViewFactory
            .hStack()
            .addSubviews(weekdays)
            .alignment(.fill)
            .distribution(.fillEqually)
            .spacing(0)
        
        return hstack
    }()
    
    private let backgroundView = UIView()
    
    private lazy var headerView = ViewFactory
        .hStack()
        .addSubviews([dateView, UIView.spacer(), monthChangeButtonsView])
        .spacing(20)
        .setEdgeInset(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
    
    private lazy var vstack = ViewFactory
        .vStack()
        .addSubviews([headerView, weekdaysView])
        .spacing(20)
    
    private lazy var eventDayCell: UIView = UIView()
    
    init(viewModel: DatePickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func beforeMonth() {
        print("left")
        viewModel.currentMonth -= 1
        viewModel.isMonthlyRecord = true
    }
    
    @objc private func forewardMonth() {
        print("right")
        viewModel.currentMonth += 1
        viewModel.isMonthlyRecord = true
    }
    
    
    private func configure() {
        
    }
    
    func updateView() {
        let month = viewModel.selectedDate.toString(.month)
        let year = viewModel.selectedDate.toString(.year)
        
        self.month.text = "\(month)월"
        self.year.text = year
    }
    
    private func layout() {
        self.addSubview(backgroundView)
        self.addSubview(vstack)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vstack.snp.makeConstraints { make in
            make.top.equalTo(backgroundView)
            make.horizontalEdges.equalTo(backgroundView)
        }
    }
    
}

#if DEBUG
import SwiftUI

struct WorkoutDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            DatePickerHeader(viewModel: DatePickerViewModel())
        }
        .frame(height: 300)
    }
}
#endif
