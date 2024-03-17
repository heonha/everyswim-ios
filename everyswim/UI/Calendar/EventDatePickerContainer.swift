//
//  EventDatePickerContainer.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/16/23.
//

import SwiftUI

struct EventDatePickerContainer: View {
    
    @ObservedObject private var viewModel = EventDatePickerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                EventDatePicker(viewModel: _viewModel)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)

                Text("수영 기록")
                    .font(.custom(.sfProMedium, size: 20))
                    .padding(.bottom, 8)
                
                List(viewModel.presentedEventData
                    .filter { $0.eventDate == viewModel.currentDate }
                    .flatMap { $0.event },
                     id: \.id) { data in
                    RecordCard(record: data)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
        }
    }
    
}

#Preview {
    EventDatePickerContainer()
}
