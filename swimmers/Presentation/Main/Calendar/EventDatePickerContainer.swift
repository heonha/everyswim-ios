//
//  EventDatePickerContainer.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/16/23.
//

import SwiftUI

struct EventDatePickerContainer: View {
    
    @ObservedObject private var viewModel = EventDatePickerViewModel()
    @State var listHeight: CGFloat = 100
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack {
                    EventDatePicker(viewModel: _viewModel)
                    
                    EventListView(viewModel: _viewModel)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    EventDatePickerContainer()
}
