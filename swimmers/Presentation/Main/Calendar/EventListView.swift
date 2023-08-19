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
        }
    }

    private func eventCellsContainer() -> some View {
        Group {
            if let workouts = viewModel.workouts.first(where: { task in
                return viewModel.isSameDay(task.taskDate, viewModel.currentDate)
            }) {
                if !workouts.event.isEmpty {
                    eventCell(workouts: workouts)
                }
            } else {
                eventCellPlaceholder()
            }
        }
    }
    
    private func eventCell(workouts: DatePickerMetaData) -> some View {
        ScrollView(showsIndicators: false) {
            ForEach(workouts.event) { workout in
                EventListCell(data: workout)
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
