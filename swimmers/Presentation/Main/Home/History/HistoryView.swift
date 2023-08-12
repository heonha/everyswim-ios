//
//  HistoryView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/05.
//

// 수영 히스토리
import SwiftUI
import Combine

struct HistoryView: View {
    
    @StateObject private var viewModel: HistoryViewModel
    @State private var showView = false
    @State private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HistoryViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        mainBody
            .onAppear {
                animateView()
                viewRefreshSubscriber()
            }
            .animation(.easeInOut.delay(0.1),
                       value: viewModel.animationRefreshPublisher)
    }
    
}

extension HistoryView {
    
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
                        
                        NavigationLink {
                            SwimDetailView(data: record)
                        } label: {
                            RecordCell(data: record)
                                .padding(.horizontal, 21)
                                .opacity( showView ? 1 : 0)
                                .offset(y: showView ? 0 : 200)
                        }

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
    
    private func sortButton(_ type: RecordSortType) -> some View {
        Button {
            viewModel.sort = type
            viewModel.fetchData()
        } label: {
            if viewModel.sort == type {
                Image(systemName: "checkmark")
            }

            Text(type.title)
        }
    }
        
}

// MARK: Handler
extension HistoryView {
    
    @Sendable
    private func refreshAction() async {
        HapticManager.triggerHapticFeedback(style: .rigid)
        viewModel.fetchData()
    }
    
    private func viewRefreshSubscriber() {
        viewModel.$animationRefreshPublisher
            .sink { _ in
                animateView()
            }
            .store(in: &cancellables)
    }
    
    private func animateView() {
        showView = false
        withAnimation(.easeInOut.delay(0.05)) {
            showView = true
        }
    }
}

#if DEBUG
struct SwimmingHistoryView_Previews: PreviewProvider {
    
    static let vm = HistoryViewModel()
    
    static var previews: some View {
        HistoryView(viewModel: HistoryViewModel())
            .onAppear {
                vm.fetchData()
            }
    }
}
#endif
