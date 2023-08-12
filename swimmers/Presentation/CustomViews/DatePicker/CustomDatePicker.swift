//
//  CustomDatePicker.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/08/07.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @ObservedObject private var viewModel = DatePickerViewModel()
    
    var tintColor = AppColor.primary
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(spacing: 35) {
            headerView()
            
            weekDayTitleView()
            
            dayGridView()
            
            taskListContainer()
        }
        .padding(.horizontal)
        .onChange(of: viewModel.currentMonth) { _ in
            viewModel.changeMonth()
        }
    }
    
}

extension CustomDatePicker {
    
    private func headerView() -> some View {
        HStack(spacing: 20) {
            yearAndMonthLabel()
            
            Spacer()
            
            changeMonthButton()
        }
        .padding(.horizontal)
    }
    
    private func yearAndMonthLabel() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.extraDate()[0])
                .font(.custom(.sfProLight, size: 14))
            
            Text(viewModel.extraDate()[1])
                .font(.custom(.sfProBold, size: 20))
        }
    }
    
    private func changeMonthButton() -> some View {
        HStack {
            Button {
                withAnimation {
                    viewModel.currentMonth -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.custom(.sfProMedium, size: 20))
                    .foregroundColor(AppColor.primary)
            }
            
            Button {
                withAnimation {
                    viewModel.currentMonth += 1
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.custom(.sfProMedium, size: 20))
                    .foregroundColor(AppColor.primary)
            }
        }
    }
    
    private func weekDayTitleView() -> some View {
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
        LazyVGrid(columns: columns, spacing: 10) {
            
            ForEach(viewModel.extractDate()) { dateValue in
                dayView(from: dateValue)
                    .background(
                        Capsule()
                            .fill(AppColor.primary)
                            .padding(.horizontal, 4)
                            .opacity(viewModel.isSameDay(dateValue.date, viewModel.currentDate) ? 1 : 0)
                    )
                    .onTapGesture {
                        viewModel.currentDate = dateValue.date
                    }
            }
            
        }
        
    }
    
    private func taskListContainer() -> some View {
        VStack {
            HStack(spacing: 16) {
                Text("기록")
                    .font(.title2.bold())
                
                Text(viewModel.currentDate.toString(.dateKr))
                    .font(.custom(.sfProLight, size: 16))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            if let task = tasks.first(where: { task in
                return viewModel.isSameDay(task.taskDate, viewModel.currentDate)
            }) {
                taskCellList(from: task)
            } else {
                taskListPlaceholder()
            }
        }
    }
    
    private func taskListPlaceholder() -> some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("운동 기록이 없습니다.")
                .font(.custom(.sfProMedium, size: 19))
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    private func taskCellList(from task: DateTaskMetaData) -> some View {
        ScrollView {
            ForEach(task.task) { task in
                VStack(alignment: .leading, spacing: 10) {
                    Text(task.time
                        .addingTimeInterval(CGFloat.random(in: 0...5000)),
                         style: .time)
                    .padding(.horizontal)
                    
                    Text(task.title)
                        .font(.title2.bold())
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .background(
                    tintColor
                        .opacity(0.5)
                        .cornerRadius(10)
                )
            }
        }
    }
    
    private func dayView(from value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { task in
                    return viewModel.isSameDay(task.taskDate, value.date)
                }) {
                    workdayCard(value, task: task)
                } else {
                    emptydayCard(value)
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    private func workdayCard(_ value: DateValue, task: DateTaskMetaData) -> some View {
        VStack {
            Text("\(value.day)")
                .font(.custom(.sfProMedium, size: 20))
                .foregroundColor((viewModel.isSameDay(task.taskDate, viewModel.currentDate)
                                  ? Color.white
                                  : .primary))
                .frame(maxWidth: .infinity)
            
            Spacer()
            
            Circle()
                .fill(viewModel.isSameDay(task.taskDate, viewModel.currentDate)
                      ? Color.white
                      : tintColor)
                .frame(width: 8, height: 8)
        }
    }
    
    private func emptydayCard(_ value: DateValue) -> some View {
        VStack {
            Text("\(value.day)")
                .font(.custom(.sfProMedium, size: 20))
                .frame(maxWidth: .infinity)
                .foregroundColor((viewModel.isSameDay(value.date, viewModel.currentDate)
                                  ? Color.white
                                  : .primary))
            
            Spacer()
        }
    }
    
}

#if DEBUG
struct CustomDatePicker_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomDatePicker()
    }
    
}
#endif
