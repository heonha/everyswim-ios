//
//  SwimmingHistoryView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/05.
//

// 수영 히스토리
import SwiftUI

struct SwimmingHistoryView: View {
    
    @StateObject private var viewModel: SwimmingHistoryViewModel
    
    init(viewModel: SwimmingHistoryViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        mainBody
    }
}

extension SwimmingHistoryView {
    
    private var mainBody: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.swimRecords, id: \.id) { record in
                        SwimmingRecordCell(data: record)
                            .padding(.horizontal, 21)
                    }
                }
                .padding(.top)
                .padding(.bottom, 4)
            }
            .refreshable {
                await viewModel.fetchData()
            }
 
        }
        .navigationTitle("수영 기록")
        .background(BackgroundObject())
    }
}

#if DEBUG
struct SwimmingHistoryView_Previews: PreviewProvider {
    
    static let viewModel = SwimmingHistoryViewModel()
    
    static var previews: some View {
        SwimmingHistoryView(viewModel: viewModel)
            .task {
                await viewModel.fetchData()
            }
    }
}
#endif
