//
//  HomeRecordsView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct HomeRecordsView: View {
    
    @ObservedObject private var viewModel = HomeRecordsViewModel(healthKitManager: HealthKitManager())
    @State private var showViews: [Bool] = Array(repeating: false, count: 4)
    
    var body: some View {
        NavigationView {
            mainBody
                .navigationBarTitleDisplayMode(.inline)
                .background(BackgroundObject())
        }
        .tint(Color.init(uiColor: .label))
    }
}

extension HomeRecordsView {
    
    private var mainBody: some View {
        
            ScrollView(showsIndicators: false) {
                profileView()
                    .frame(height: 100)
                    .padding(.horizontal, 24)
                
                Group {
                    RecentHistoryCell(destination: AnyView(HistoryView()),
                                      lastWorkout: $viewModel.lastWorkout)
                        .opacity(showViews[0] ? 1 : 0)
                        .offset(y: showViews[0] ? 0 : 200)
                        .padding(.bottom, 14)
                    
                    ChallangeRingView(rings: $viewModel.rings)
                        .frame(height: 170)
                        .opacity(showViews[1] ? 1 : 0)
                        .offset(y: showViews[1] ? 0 : 200)
                        .padding(.bottom, 14)
                    
                    bodyView()
                        .opacity(showViews[2] ? 1 : 0)
                        .offset(y: showViews[2] ? 0 : 200)
                    
                    kcalCell()
                        .opacity(showViews[2] ? 1 : 0)
                        .offset(y: showViews[2] ? 0 : 200)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                        .frame(height: 30)
                }
                .padding(.horizontal, 20)

            }
            .onAppear(perform: animateView)
            
    }
    
    private func kcalCell() -> some View {
            
        ZStack {
            CellBackground()
            
            HStack {
                Image("flame")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(AppColor.caloriesRed)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.leading)
                
                HStack(alignment: .bottom) {
                    Text("2,683")
                        .font(.custom(.sfProBold, size: 24))
                        .foregroundColor(.init(uiColor: .label))
                    
                    Text("kcal")
                        .font(.custom(.sfProBold, size: 16))
                        .foregroundColor(.gray)
                        .offset(y: -2)
                }
            }
        }
        .frame(height: 60)

    }
    
    private func bodyView() -> some View {
        VStack(spacing: 16) {
            ForEach(viewModel.rings) { ring in
                EachChallangeCircleCell(ring: ring)
            }
            Spacer()
        }
    }
    
    
    private func centerRecordView() -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                recordsCell(.swim, score: Int(viewModel.strokePerMonth))
                recordsCell(.speed, score: 0)
            }
            HStack(spacing: 16) {
                recordsCell(.kcal, score: Int(viewModel.kcalPerWeek))
                recordsCell(.lap, score: 0)
            }
        }
        .frame(width: Constant.deviceSize.width / 1.5)
    }
    
    private func recordsCell(_ type: RecordCellType, score: Int) -> some View {
        Group {
            VStack(spacing: 4) {
                Group {
                    Image(systemName: type.symbolName())
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(type.getSymbolColor())
                }
                .frame(width: 50, height: 27)
                
                Text(score < 0 ? "-" : "\(score)")
                    .font(.custom(.sfProBold, size: 30))
                
                Text(type.getUnit())
                    .font(.custom(.sfProBold, size: 17))
                    .foregroundColor(.init(hex: "000000").opacity(0.3))
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.95))
                    .frame(height: 128)
                    .shadow(color: .black.opacity(0.16), radius: 5, x: 1, y: 1)
            }
        }
    }
    
    private func profileView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("반가워요, Heon Ha!👋")
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundColor(Color.init(uiColor: .secondaryLabel))
                
                Text("오늘도 화이팅 해볼까요?")
                    .font(.custom(.sfProBold, size: 21))
                    .foregroundColor(Color.init(uiColor: .label))
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            
            Spacer()
            
            ZStack {
                Image("Avatar")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            }
            .frame(width: 56, height: 56)
            .shadow(color: .black.opacity(0.16), radius: 4, x: 1, y: 1)
        }
    }
    
    private func animateView() {
        withAnimation(.easeInOut.delay(0.1)) {
            showViews[0] = true
        }
        
        withAnimation(.easeInOut.delay(0.20)) {
            showViews[1] = true
        }
        
        withAnimation(.easeInOut.delay(0.25)) {
            showViews[2] = true
        }
        
    }
    
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
