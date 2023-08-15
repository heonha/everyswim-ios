//
//  WorkoutDatePicker.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/08/07.
//

import SwiftUI

struct WorkoutDatePicker: View {
        
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    private var tintColor = AppColor.primary

    @ObservedObject private var viewModel = WorkoutDatePickerViewModel()
    
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

                taskListContainer()
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

extension WorkoutDatePicker {
    
    private func calendarContainer() -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
            
            VStack(spacing: 4) {
                headerView()
                
                weekDayTitleView()
                
                dayGridView()
                
                Divider()
                
                Spacer()
            }
        }
    }

    private func headerView() -> some View {
        HStack(spacing: 20) {
            yearAndMonthLabel()
            
            Spacer()
            
            changeMonthButton()
        }
        .padding(.horizontal, 8)
    }
    
    private func yearAndMonthLabel() -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            Text(viewModel.extraDate()[1])
                .font(.custom(.sfProBold, size: 22))
            
            Text(viewModel.extraDate()[0])
                .font(.custom(.sfProLight, size: 16))

        }
        .padding(.vertical)
    }
    
    private func changeMonthButton() -> some View {
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
        LazyVGrid(columns: columns, spacing: 2) {
            
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
        ZStack {
            Rectangle()
                .fill(.clear)

            VStack {
                HStack(spacing: 16) {
                    Text("기록")
                        .font(.title2.bold())
                    
                    Text(viewModel.currentDate.toString(.dateKr))
                        .font(.custom(.sfProLight, size: 16))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                if let task = viewModel.workouts.first(where: { task in
                    return viewModel.isSameDay(task.taskDate, viewModel.currentDate)
                }) {
                    if let workout = task.task.first {
                        ScrollView(showsIndicators: false) {
                            ForEach(task.task) { workout in
                                NavigationLink {
                                    SwimDetailView(data: workout)
                                } label: {
                                    RecordCell(data: workout)
                                        .frame(height: 150)
                                        .padding(4)
                                }
                            }
                        }
                    }
                } else {
                    taskListPlaceholder()
                }
                
                Spacer()
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
    
    private func taskCellList(from workout: DatePickerMetaData) -> some View {
        ScrollView {
            ForEach(workout.task) { task in
                VStack(alignment: .leading, spacing: 10) {
                    Text(Date().addingTimeInterval(CGFloat.random(in: 0...5000)),
                         style: .time)
                    .padding(.horizontal)
                    
                    Text(task.date)
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
                if let task = viewModel.workouts.first(where: { task in
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
    
    private func workdayCard(_ value: DateValue, task: DatePickerMetaData) -> some View {
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
struct WorkoutDatePicker_Previews: PreviewProvider {
    
    static var previews: some View {
        WorkoutDatePicker()
    }
    
}
#endif
