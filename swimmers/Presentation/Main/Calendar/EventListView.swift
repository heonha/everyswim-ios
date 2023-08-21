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
            ScrollView(showsIndicators: false) {
                if !viewModel.workouts.isEmpty {
                    dailyAndMonthlySwitcher()
                } else {
                    eventCellPlaceholder()
                }
            }
        }
    }
    
    private func dailyAndMonthlySwitcher() -> some View {
        Group {
            if viewModel.isMonthlyRecord {
                monthlyEventList(viewModel.workouts)
            } else {
                let dayMetadata = viewModel.extractFirstEvent(date: viewModel.currentDate)
                if let dayMetadata = dayMetadata {
                    dailyEventList(dayMetadata)
                } else {
                    eventCellPlaceholder()
                }
            }
        }
    }
    
    private func dailyEventList(_ workout: DatePickerMetaData) -> some View {
        ForEach(workout.event) { workout in
            EventListCell(data: workout)
        }
    }
    
    private func monthlyEventList(_ workouts: [DatePickerMetaData]) -> some View {
        ForEach(workouts) { workout in
            ForEach(workout.event) { event in
                EventListCell(data: event)
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
        .frame(minHeight: 200, idealHeight: 300)
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
