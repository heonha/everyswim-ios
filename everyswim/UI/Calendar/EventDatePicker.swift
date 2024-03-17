//
//  EventDatePicker.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/08/07.
//

import SwiftUI

struct EventDatePicker: View {
    
    private var tintColor = AppColor.labelTint
    
    @ObservedObject private var viewModel: EventDatePickerViewModel
    
    init(viewModel: ObservedObject<EventDatePickerViewModel>) {
        self._viewModel = viewModel
    }
    
    var body: some View {
        calendarContainer()
            .onChange(of: viewModel.currentMonth) { _ in
                viewModel.changeMonth()
            }
            .task {
                await viewModel.subscribeSwimData()
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
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColor.darkGrayTint)
                    
                    VStack {
                        weekdayTitleView()
                        
                        carendarDaysGrid()
                            .transition(.slide)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                }
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
        HStack(spacing: 20) {
            Button {
                viewModel.currentMonth -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .font(.custom(.sfProMedium, size: 20))
                    .foregroundColor(AppColor.grayTint)
            }
            
            Button {
                viewModel.currentMonth += 1
            } label: {
                Image(systemName: "chevron.right")
                    .font(.custom(.sfProMedium, size: 20))
                    .foregroundColor(AppColor.grayTint)
            }
        }
        .padding(.trailing)
    }
    
    private func weekdayTitleView() -> some View {
        HStack(spacing: 0) {
            ForEach(Weekdays.values, id: \.self) { weekDay in
                Text(weekDay)
                    .font(.custom(.sfProBold, size: 14))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func carendarDaysGrid() -> some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 2) {
            ForEach(viewModel.extractDayInCarendar()) { dateValue in
                dayCellContainer(from: dateValue)
            }
        }
    }
    
    private func dayCellContainer(from value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                Group {
                    if viewModel.extractFirstEvent(date: value.date) != nil {
                        eventDayCell(value)
                    } else {
                        noEventDayCell(value)
                    }
                }
                .background(dayViewBackground(value))
            }
        }
        .padding(.vertical, 9)
        .frame(height: 50, alignment: .center)
        .onTapGesture {
            viewModel.currentDate = value.date
            viewModel.isMonthlyRecord = false
        }
    }
    
    private func dayViewBackground(_ value: DateValue) -> some View {
        let circleColor = LinearGradient(colors: AppColor.Gradient.calendarDayTint,
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing)
        return Circle()
            .stroke(lineWidth: 2.0)
            .fill(circleColor)
            .border(.clear)
            .padding(.horizontal, 4)
            .opacity(viewModel.isSameDay(value.date, viewModel.currentDate) ? 1 : 0)
            .shadow(color: .black.opacity(0.5), radius: 1.5)
            .frame(width: 46, height: 46)
    }
    
    private func eventDayCell(_ value: DateValue) -> some View {
        let textColor = Color.white
        let circleColor = LinearGradient(colors: AppColor.Gradient.calendarDayTint,
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing)
        
        return ZStack {
            Circle()
                .fill(circleColor)
            
            Text("\(value.day)")
                .font(.custom(.sfProBold, size: 16))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 36, height: 36)
        
    }
    
    private func noEventDayCell(_ value: DateValue) -> some View {
        let textColor = viewModel.isSameDay(value.date, viewModel.currentDate) ? Color.white : .primary
        
        return ZStack {
            Text("\(value.day)")
                .font(.custom(.sfProMedium, size: 16))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 36, height: 36)
        
    }
    
}

#Preview {
    EventDatePicker(viewModel: .init(initialValue: .init()))
}
