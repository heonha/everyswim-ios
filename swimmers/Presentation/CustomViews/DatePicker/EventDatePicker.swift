//
//  EventDatePicker.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/08/07.
//

import SwiftUI

struct EventDatePicker: View {
        
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    private var tintColor = AppColor.primary

    @ObservedObject private var viewModel = EventDatePickerViewModel()
    
    var body: some View {
        NavigationView {
            mainBody
                .onChange(of: viewModel.currentMonth) { _ in
                    viewModel.changeMonth()
                }
                .task {
                    await viewModel.subscribeSwimData()
                }
        }
    }
    
    var mainBody: some View {
        ZStack(alignment: .top) {
            
            VStack {
                calendarContainer()

                EventListView(viewModel: _viewModel)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

extension EventDatePicker {
    
    private func calendarContainer() -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
            
            VStack(spacing: 4) {
                headerView()
                
                weekdayTitleView()
                
                dayGridView()
                
                Divider()
                
                Spacer()
            }
        }
    }

    private func headerView() -> some View {
        HStack(spacing: 20) {
            headerDateLabel()
            
            Spacer()
            
            headerMoveMonthButtons()
        }
        .padding(.horizontal, 8)
    }
    
    private func headerDateLabel() -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            Text(viewModel.extraDate()[1])
                .font(.custom(.sfProBold, size: 22))
            
            Text(viewModel.extraDate()[0])
                .font(.custom(.sfProLight, size: 16))

        }
        .padding(.vertical)
    }
    
    private func headerMoveMonthButtons() -> some View {
        HStack(spacing: 14) {
            Button {
                viewModel.currentMonth -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .font(.custom(.sfProMedium, size: 20))
                    .foregroundColor(AppColor.primary)
            }
            
            Button {
                viewModel.currentMonth += 1
            } label: {
                Image(systemName: "chevron.right")
                    .font(.custom(.sfProMedium, size: 20))
                    .foregroundColor(AppColor.primary)
            }
        }
    }
    
    private func weekdayTitleView() -> some View {
        HStack(spacing: 0) {
            ForEach(weekdays, id: \.self) { weekDay in
                Text(weekDay)
                    .font(.custom(.sfProMedium, size: 16))
                    .foregroundColor(AppColor.grayTint)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func dayGridView() -> some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(viewModel.extractDate()) { dateValue in
                dayCellContainer(from: dateValue)
            }
        }
    }
    
    private func dayCellContainer(from value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                let hasEvent = viewModel.workouts.first { task in
                    return viewModel.isSameDay(task.taskDate, value.date)
                }
                
                if let event = hasEvent {
                    eventDayCell(value, task: event)
                } else {
                    noEventDayCell(value)
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
        .background(dayViewBackground(value))
        .onTapGesture {
            viewModel.currentDate = value.date
        }
    }
    
    private func dayViewBackground(_ value: DateValue) -> some View {
        Capsule()
            .fill(AppColor.primary)
            .padding(.horizontal, 4)
            .opacity(viewModel.isSameDay(value.date, viewModel.currentDate) ? 1 : 0)
    }
    
    private func eventDayCell(_ value: DateValue, task: DatePickerMetaData) -> some View {
        let textColor = viewModel
            .isSameDay(task.taskDate, viewModel.currentDate) ? Color.white : .primary
        let circleColor = viewModel
            .isSameDay(task.taskDate, viewModel.currentDate) ? Color.white : tintColor
        
        return VStack {
            Text("\(value.day)")
                .font(.custom(.sfProMedium, size: 20))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
            
            Spacer()
            
            Circle()
                .fill(circleColor)
                .frame(width: 8, height: 8)
        }
    }
    
    private func noEventDayCell(_ value: DateValue) -> some View {
        let textColor = viewModel.isSameDay(value.date, viewModel.currentDate) ? Color.white : .primary
        
        return VStack {
            Text("\(value.day)")
                .font(.custom(.sfProMedium, size: 20))
                .frame(maxWidth: .infinity)
                .foregroundColor(textColor)
            
            Spacer()
        }
    }
    
}

#if DEBUG
struct WorkoutDatePicker_Previews: PreviewProvider {
    
    static var previews: some View {
        EventDatePicker()
    }
    
}
#endif
