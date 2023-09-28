// //
// //  HistoryView.swift
// //  swimmers
// //
// //  Created by HeonJin Ha on 2023/07/05.
// //
// 
// // 수영 히스토리
// import SwiftUI
// import Combine
// 
// struct HistoryView: View {
//     
//     @StateObject private var viewModel: HistoryViewModel
//     @State private var showView = false
//     @State private var cancellables = Set<AnyCancellable>()
//     
//     init(viewModel: HistoryViewModel = .init()) {
//         _viewModel = StateObject(wrappedValue: viewModel)
//     }
//     
//     var body: some View {
//         mainBody
//             .onAppear {
//                 animateView()
//                 viewRefreshSubscriber()
//             }
//             .animation(.easeInOut.delay(0.1),
//                        value: viewModel.animationRefreshPublisher)
//             .toolbar {
//                 ToolbarItem(id: UUID().uuidString, placement: .topBarTrailing) {
//                     sortMenu()
//                 }
//             }
//     }
//     
// }
// 
// extension HistoryView {
//     
//     private var mainBody: some View {
//         VStack {
//             list
//         }
//         .navigationTitle("수영 기록")
//         .background(AppColor.skyBackground)
//      
//     }
//     
//     private var list: some View {
//         ScrollView {
//             VStack(spacing: 16) {
//                 ForEach(viewModel.swimRecords, id: \.id) { record in
//                     NavigationLink {
//                         SwimDetailView(data: record)
//                     } label: {
//                         RecordCell(data: record)
//                             .opacity( showView ? 1 : 0)
//                             .offset(y: showView ? 0 : 200)
//                     }
//                 }
//             }
//             .padding(.top)
//             .padding(.bottom, 4)
//         }
//         .refreshable(action: refreshAction)
//     }
// 
//     
//     private func sortMenu() -> some View {
//         Menu {
//             sortButton(.date)
//             
//             sortButton(.distance)
//             
//             sortButton(.duration)
//              
//             sortButton(.kcal)
//         } label: {
//             ZStack {
//                 RoundedRectangle(cornerRadius: 8)
//                     .fill(.white.opacity(0.97))
//                     .frame(width: 100)
//                 
//                 Text("\(viewModel.sortType.title) ↓")
//                     .font(.custom(.sfProLight, size: 16))
//                     .foregroundColor(.init(uiColor: .label))
//                     .padding(4)
//             }
//         }
//         .frame(width: 100, height: 30)
//     }
//     
//     private func sortButton(_ type: RecordSortType) -> some View {
//         Button {
//             viewModel.sortRecords(sortType: type)
//         } label: {
//             Group {
//                 if viewModel.sortType == type {
//                     Image(systemName: "checkmark")
//                 }
// 
//                 Text(type.title)
//             }
//         }
// 
//     }
//     
//     func sortAction(type: RecordSortType) {
//     }
//         
// }
// 
// // MARK: Handler
// extension HistoryView {
//     
//     @Sendable
//     private func refreshAction() async {
//         HapticManager.triggerHapticFeedback(style: .rigid)
//         viewModel.fetchData()
//     }
//     
//     private func viewRefreshSubscriber() {
//         viewModel.$animationRefreshPublisher
//             .sink { _ in
//                 animateView()
//             }
//             .store(in: &cancellables)
//     }
//     
//     private func animateView() {
//         showView = false
//         withAnimation(.easeInOut.delay(0.05)) {
//             showView = true
//         }
//     }
// }
// 
// #if DEBUG
// struct SwimmingHistoryView_Previews: PreviewProvider {
//     
//     static let vm = HistoryViewModel()
//     
//     static var previews: some View {
//         HistoryView(viewModel: HistoryViewModel())
//             .onAppear {
//                 vm.fetchData()
//             }
//     }
// }
// #endif
