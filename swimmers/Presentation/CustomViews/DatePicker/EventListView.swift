//
//  EventListView.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/16/23.
//

import SwiftUI

struct EventListView: View {
    
    @ObservedObject private var viewModel: EventDatePickerViewModel
    private var tintColor = AppColor.primary

    var body: some View {
        eventListContainer()
    }
    
    init(viewModel: ObservedObject<EventDatePickerViewModel>) {
        self._viewModel = viewModel
    }
    
    // MARK: - Event Cells
    private func eventListContainer() -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
            
            VStack {
                eventListHeader()
                
                eventCell()
                
                Spacer()
            }
        }
    }
    
    private func eventListHeader() -> some View {
        HStack(spacing: 16) {
            Text("기록")
                .font(.title2.bold())
            
            Text(viewModel.currentDate.toString(.dateKr))
                .font(.custom(.sfProLight, size: 16))
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    private func eventCellList(from workout: DatePickerMetaData) -> some View {
        ScrollView {
            ForEach(workout.event) { task in
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
    
    private func eventCell() -> some View {
        Group {
            if let workouts = viewModel.workouts.first(where: { task in
                return viewModel.isSameDay(task.taskDate, viewModel.currentDate)
            }) {
                if let workout = workouts.event.first {
                    ScrollView(showsIndicators: false) {
                        ForEach(workouts.event) { workout in
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
                eventCellPlaceholder()
            }
        }
    }
    
    
    private func eventCellPlaceholder() -> some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("운동 기록이 없습니다.")
                .font(.custom(.sfProMedium, size: 19))
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    

}
