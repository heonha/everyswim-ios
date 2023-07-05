//
//  SwimmingHistoryView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/05.
//

// 수영 히스토리
import SwiftUI

struct SwimmingHistoryView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        mainBody
    }
}

extension SwimmingHistoryView {
    
    
    private var mainBody: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Range(1...10)) { _ in
                    SwimmingRecordCell()
                        .padding(.horizontal, 21)
                }
            }
            .padding(.top)
            .padding(.bottom, 4)
        }
        .navigationTitle("수영 기록")
        .task {
            await viewModel.loadSwimmingDataCollection()
        }
    }
}

struct SwimmingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SwimmingHistoryView()
                .environmentObject(HomeViewModel())
        }
    }
}
