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
    @State var showView = false
    
    init(viewModel: SwimmingHistoryViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        mainBody
            .onAppear {
                animateView()
            }
    }
}

extension SwimmingHistoryView {
    
    private var mainBody: some View {
        VStack {
            
            HStack {
                Spacer()
                
                sortMenu
                    .padding(.trailing, 21)
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.swimRecords, id: \.id) { record in
                        SwimmingRecordCell(data: record)
                            .padding(.horizontal, 21)
                            .opacity(showView ? 1 : 0)
                            .offset(y: showView ? 0 : 200)

                    }
                }
                .padding(.top)
                .padding(.bottom, 4)
            }
            .refreshable(action: refreshAction)
 
        }
        .navigationTitle("수영 기록")
        .background(BackgroundObject())
    }
    
    @Sendable
    private func refreshAction() async {
        HapticManager.shared.triggerHapticFeedback(style: .rigid)
        viewModel.fetchData()
    }
    
    // TODO: 애니메이션 싱크 맞추기
    private func animateView() {
        showView = false
        withAnimation(.easeInOut.delay(0.1)) {
            showView = true
        }
    }
    
    // TODO: 오름차순 / 내림차순 구현
    private var sortMenu: some View {
        Menu {
            sortButton(.date)
            
            sortButton(.distance)
            
            sortButton(.duration)
            
            sortButton(.kcal)

        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.thickMaterial)
                
                Text("\(viewModel.sort.title) ↓")
                    .foregroundColor(.init(uiColor: .label))
            }
        }
        .frame(width: 100, height: 30)
    }
    private func sortButton(_ type: SortType) -> some View {
        Button {
            viewModel.sort = type
                viewModel.fetchData()
                animateView()
        } label: {
            if viewModel.sort == type {
                Image(systemName: "checkmark")
            }

            Text(type.title)
        }
    }
        
}

#if DEBUG
struct SwimmingHistoryView_Previews: PreviewProvider {
    
    static let viewModel = SwimmingHistoryViewModel()
    
    static var previews: some View {
        SwimmingHistoryView(viewModel: viewModel)
            .onAppear {
                viewModel.fetchData()
            }
    }
}
#endif
