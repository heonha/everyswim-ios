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
                
                EventListView(viewModel: _viewModel)
            }
        }
    }
}

#Preview {
    EventDatePickerContainer()
}
