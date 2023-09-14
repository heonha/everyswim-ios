//
//  WorkoutDatePicker.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit

final class WorkoutDatePicker: UIView {
    
    private let viewModel: EventDatePickerViewModel
    
    private lazy var headerDateLabel: UIView = {
        
        let month = ViewFactory
            .label(viewModel.extraDate()[1])
            .font(.custom(.sfProBold, size: 22))

        
        let year = ViewFactory
            .label(viewModel.extraDate()[0])
            .font(.custom(.sfProLight, size: 16))

        let hstack = ViewFactory
            .hStack()
            .addSubviews([month, year])
            .alignment(.bottom)
            .distribution(.fillProportionally)
            .spacing(10)
            .setEdgeInset(.init(top: 0, leading: 6, bottom: 0, trailing: 6))
            .randomBackgroundColor()

        return hstack
    }()
    
    private lazy var headerMoveMonthButtons: UIView = {
        
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
    
    private lazy var weekdayTitleView: UIView = {
        let weekdays = Weekdays.values
            .map { weekday -> UILabel in
                let label = ViewFactory.label(weekday)
                    .font(.custom(.sfProBold, size: 14))
                    .foregroundColor(AppUIColor.grayTint)
                label.textAlignment = .center
                label.backgroundColor = UIColor.randomColor()
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
        .addSubviews([headerDateLabel, UIView.spacer(), headerMoveMonthButtons])
        .spacing(20)
        .setEdgeInset(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
        .randomBackgroundColor()
        
    private lazy var calendarDaysGrid: UIView = {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        // TODO: CollectionView로 구성해야할듯 하위뷰부터.
        //
        //         return LazyVGrid(columns: columns, spacing: 2) {
        //             ForEach(viewModel.extractDayInCarendar()) { dateValue in
        //                 dayCellContainer(from: dateValue)
        //             }
        //         }
        return UIView()
    }()
    
    private lazy var vstack = ViewFactory
        .vStack()
        .addSubviews([headerView,
                      weekdayTitleView,
                      calendarDaysGrid,
                      UIView.spacer()])
        .spacing(4)
    
    private lazy var eventDayCell: UIView = UIView()
    
    init(viewModel: EventDatePickerViewModel) {
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
    }
    
    @objc private func forewardMonth() {
        print("right")
        viewModel.currentMonth += 1
    }
    
    
    private func configure() {
        
    }
    
    private func layout() {
        self.addSubview(backgroundView)
        self.addSubview(vstack)
        backgroundView.backgroundColor = .lightGray
        vstack.backgroundColor = UIColor.randomColor()
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vstack.snp.makeConstraints { make in
            make.top.equalTo(backgroundView)
            make.horizontalEdges.equalTo(backgroundView)
        }
        
    }
    
    
}


// extension EventDatePicker {


//     
    // private func carendarDaysGrid() -> some View {
    //     let columns = Array(repeating: GridItem(.flexible()), count: 7)
    //     
    //     return LazyVGrid(columns: columns, spacing: 2) {
    //         ForEach(viewModel.extractDayInCarendar()) { dateValue in
    //             dayCellContainer(from: dateValue)
    //         }
    //     }
    // }
//     
//     private func dayCellContainer(from value: DateValue) -> some View {
//         VStack {
//             if value.day != -1 {
//                 Group {
//                     if viewModel.extractFirstEvent(date: value.date) != nil {
//                         eventDayCell(value)
//                     } else {
//                         noEventDayCell(value)
//                     }
//                 }
//                 .background(dayViewBackground(value))
//             }
//         }
//         .padding(.vertical, 9)
//         .frame(height: 50, alignment: .center)
//         .onTapGesture {
//             viewModel.currentDate = value.date
//             viewModel.isMonthlyRecord = false
//         }
//     }
//     
//     private func dayViewBackground(_ value: DateValue) -> some View {
//         Circle()
//             .fill(Color.white)
//             .border(.clear)
//             .padding(.horizontal, 4)
//             .opacity(viewModel.isSameDay(value.date, viewModel.currentDate) ? 1 : 0)
//             .shadow(color: .black.opacity(0.5), radius: 1.5)
//             .frame(width: 46, height: 46)
//     }
//     
//     private func eventDayCell(_ value: DateValue) -> some View {
//         let textColor = Color.white
//         let circleColor = tintColor
//         
//         return ZStack {
//             Circle()
//                 .fill(circleColor)
//             
//             Text("\(value.day)")
//                 .font(.custom(.sfProBold, size: 16))
//                 .foregroundColor(textColor)
//                 .frame(maxWidth: .infinity)
//         }
//         .frame(width: 36, height: 36)
//         
//     }
//     
//     private func noEventDayCell(_ value: DateValue) -> some View {
//         let textColor = viewModel.isSameDay(value.date, viewModel.currentDate) ? Color.black : .primary
//         
//         return ZStack {
//             Text("\(value.day)")
//                 .font(.custom(.sfProMedium, size: 16))
//                 .foregroundColor(textColor)
//                 .frame(maxWidth: .infinity)
//         }
//         .frame(width: 36, height: 36)
//         
//     }
//     
// }


#if DEBUG
import SwiftUI

struct WorkoutDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            WorkoutDatePicker(viewModel: EventDatePickerViewModel())
        }
        .frame(height: 300)
    }
}
#endif
