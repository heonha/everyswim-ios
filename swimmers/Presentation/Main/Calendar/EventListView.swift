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
            VStack {
                eventListHeader()
                    .padding(.top)

                eventCellsContainer()
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(AppColor.skyBackground)
        .frame(maxHeight: .infinity)
    }
    
    private func eventListHeader() -> some View {
        HStack(spacing: 16) {
            Text("수영 기록")
                .font(.custom(.sfProMedium, size: 20))
                        
            Spacer()
            
                Button {
                    viewModel.isMonthlyRecord.toggle()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: viewModel.isMonthlyRecord ? "checkmark.circle.fill": "circle" )
                        
                        Text("월간 기록보기")
                            .font(.custom(.sfProLight, size: 16))
                    }
                }
                .tint(.black)
        }
    }

    private func eventCellsContainer() -> some View {
        Group {
            if let workouts = viewModel.workouts.first(where: { task in
                return viewModel.isSameDay(task.taskDate, viewModel.currentDate)
            }) {
                if !workouts.event.isEmpty {
                    if viewModel.isMonthlyRecord {
                        eventCellsMonthly(viewModel.workouts)
                    } else {
                        eventCell(workouts)
                    }
                }
            } else {
                eventCellPlaceholder()
            }
        }
    }
    
    private func eventCell(_ workout: DatePickerMetaData) -> some View {
        ScrollView(showsIndicators: false) {
            ForEach(workout.event) { workout in
                EventListCell(data: workout)
            }
        }
    }
    
    private func eventCellsMonthly(_ workouts: [DatePickerMetaData]) -> some View {
        ScrollView(showsIndicators: false) {
            ForEach(workouts) { workout in
                ForEach(workout.event) { event in
                    EventListCell(data: event)
                }
            }
        }
    }
    
    
    private func eventCellPlaceholder() -> some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("수영 기록이 없습니다.")
                .font(.custom(.sfProMedium, size: 19))
                .foregroundColor(.gray)
            
            Spacer()
        }
    }

}

#if DEBUG
struct EventListView_Previews: PreviewProvider {
    
    static var viewModel = ObservedObject<EventDatePickerViewModel>.init(initialValue: EventDatePickerViewModel())
    
    static var previews: some View {
        // EventListView(viewModel: viewModel)
        EventDatePickerContainer()
    }
}
#endif
