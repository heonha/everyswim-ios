//
//  HomeRecordsView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct HomeRecordsView: View {
    
    @ObservedObject private var viewModel = HomeRecordsViewModel()
    @State private var showViews: [Bool] = Array(repeating: false, count: 3)
    
    var body: some View {
        NavigationView {
            mainBody
        }
        .tint(.black)

    }
}

extension HomeRecordsView {

    
    private var mainBody: some View {
        
        ZStack {
            ScrollView {
                profileView()
                    .frame(height: 100)
                    .padding(.horizontal, 24)
                                
                    ChallangeRingView(rings: $viewModel.rings)
                        .frame(height: 150)
                        .opacity(showViews[0] ? 1 : 0)
                        .offset(y: showViews[0] ? 0 : 200)
                    
                    Spacer()
                    
                    bodyView()
                    .opacity(showViews[1] ? 1 : 0)
                    .offset(y: showViews[1] ? 0 : 200)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                        .frame(height: 30)
                    
            }
            .overlay(alignment: .bottom) {
                pushHistoryView()
                    .padding(.bottom)
                    .opacity(showViews[2] ? 1 : 0)
                    .offset(y: showViews[2] ? 0 : 200)
            }
            .onAppear(perform: animateView)

        }
        .background {
            LinearGradient(
                gradient:
                    Gradient(colors: [
                        Color(hex: "3284FE").opacity(0.08),
                        Color(hex: "FFFFFF")]),
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
        }

    }
    
    private func pushHistoryView() -> some View {
        NavigationLink {
            SwimmingHistoryView()
                .environmentObject(viewModel)
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.16), radius: 4, x: 1, y: 1)
                
                HStack(spacing: 30) {
                    Text("1,100 M")
                        .font(.custom(.sfProBold, size: 24))
                        .foregroundColor(.black)
                    
                    Text("30 Lap")
                        .font(.custom(.sfProBold, size: 21))
                        .foregroundColor(.black.opacity(0.3))
                }
                
                HStack {
                    Spacer()
                    
                    Text("3일 전")
                        .font(.custom(.sfProLight, size: 12))
                        .foregroundColor(.black.opacity(0.3))
                    
                    Image(systemName: "chevron.right")
                        .font(.custom(.sfProBold, size: 14))
                        .foregroundColor(.black.opacity(0.3))
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 4)
                }
            }
            .frame(height: 48)
            .padding(.horizontal, 24)
        }
    }
    
    private func bodyView() -> some View {
        VStack {
            Spacer()
            
            centerRecordView()
            
            Spacer()
        }
        .padding([.horizontal, .top], 14)
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
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.95))
                    .frame(height: 128)
                    .shadow(color: .black.opacity(0.16), radius: 5, x: 1, y: 1)
                
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
            }
        }
    }
    
    private func profileView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("반가워요, Heon Ha!👋")
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundColor(.black.opacity(0.30))
                
                Text("오늘도 화이팅 해볼까요?")
                    .font(.custom(.sfProBold, size: 21))
                    .foregroundColor(.black)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
        HomeRecordsView()
    }
}
