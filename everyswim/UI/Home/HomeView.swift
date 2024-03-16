//
//  HomeView.swift
//  everyswim
//
//  Created by HeonJin Ha on 3/16/24.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 24) {
                welcomeCard()
                
                swimCard(title: "오늘의 수영")
                
                weekSwimCard(title: "이번주 수영")
                
                Spacer()
            }
            
        }
        .ignoresSafeArea(edges: .top)
        
    }
    
}

extension HomeView {
    
    // MARK: Today Swim Card
    private func swimCard(title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(.sfProBold, size: 22))
                .foregroundStyle(Color.white.opacity(0.8))

            swimCardContents()
        }
        .padding(.horizontal, 14)
    }
    
    private func weekSwimCard(title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(.sfProBold, size: 22))
                .foregroundStyle(Color.white.opacity(0.8))
            weekSwimCardContents()
        }
        .padding(.horizontal, 14)
    }
    
    private func weekSwimCardContents() -> some View {
        Group {
                GeometryReader { geometry in
                    ZStack {
                        LinearGradient(colors: [.init(uiColor: .init(hex: "2B303C", alpha: 0.9)),
                                                .init(uiColor: .init(hex: "474C5A", alpha: 0.9)) ],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                        ZStack {
                            HStack {
                                // meter, swim icon
                                VStack(alignment: .leading) {
                                    VStack(alignment: .trailing, spacing: -4) {
                                        Text("1,500")
                                            .font(.custom(.sfProBold, size: 38))
                                        Text("Meters")
                                            .font(.custom(.sfProBold, size: 14))
                                    }
                                    
                                    Spacer()
                                }
                                /// - 우측
                                ///     - 시간, 랩, 페이스, 칼로리
                                ///     - pt- 14, 16, bold
                                
                                HStack(spacing: 4) {
                                    VStack(alignment: .center, spacing: 12) {
                                        inCardRecord(title: "시간", record: "1:20:35", axis: .vertical)

                                        inCardRecord(title: "랩", record: "25", axis: .vertical)
                                    }
                                    
                                    VStack(spacing: 12) {
                                        inCardRecord(title: "페이스", record: "1'22''/25m", axis: .vertical)
                                        
                                        inCardRecord(title: "칼로리", record: "1,250 kcal", axis: .vertical)
                                    }
                                }
                                .frame(width: (geometry.size.width / 1.6) - 44)
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 12)

                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(height: 110)
        }
    }
}

// MARK: 어느정도 됨
extension HomeView {
    
    private func swimCardContents() -> some View {
        Group {
                GeometryReader { geometry in
                    ZStack {
                            LinearGradient(colors: [.init(uiColor: .init(hex: "0080EC", alpha: 0.9)),
                                                    .init(uiColor: .init(hex: "2083B9", alpha: 0.9)) ],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        ZStack {
                            HStack {
                                // meter, swim icon
                                VStack(alignment: .leading) {
                                    VStack(alignment: .trailing, spacing: -4) {
                                        Text("1,500")
                                            .font(.custom(.sfProBold, size: 44))
                                        Text("Meters")
                                            .font(.custom(.sfProBold, size: 16))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(.figurePoolSwim)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 30)
                                }

                                VStack(spacing: 4) {
                                    inCardRecord(title: "시간", record: "1:20:35", axis: .horizontal)
                                    inCardRecord(title: "랩", record: "25", axis: .horizontal)
                                    inCardRecord(title: "페이스", record: "1'22''/25m", axis: .horizontal)
                                    inCardRecord(title: "칼로리", record: "1,250 kcal", axis: .horizontal)
                                }
                                .frame(width: (geometry.size.width / 1.8) - 40)
                                
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 18)

                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(height: 160)
        }
    }
    
    /// - 우측
    ///     - 시간, 랩, 페이스, 칼로리
    ///     - pt- 14, 16, bold
    private func inCardRecord(title: String, record: String, axis: Axis) -> some View {
        ZStack {
            // Color.red
            
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(.clear)
                    
                    VStack {
                        if axis == .horizontal {
                            ZStack {
                                HStack(spacing: 4) {
                                    
                                    Text(title)
                                        .font(.custom(.sfProBold, size: 13))
                                        .frame(width: geometry.size.width / 2.5)
                                    
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text(record)
                                            .font(.custom(.sfProBold, size: 14))
                                        Spacer()
                                    }

                                }
                            }
                        } else {
                            VStack(spacing: 0) {
                                Text(title)
                                    .font(.custom(.sfProMedium, size: 13))
                                    .frame(width: .infinity, height: geometry.size.height / 2)
                                Text(record)
                                    .font(.custom(.sfProBold, size: 16))
                                    .frame(width: .infinity, height: geometry.size.height / 2)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 주차별 기록
    
    // MARK: 상단 "안녕하세요, 프로필" 뷰
    private func welcomeCard() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Material.ultraThin)
                .frame(height: 180)
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("반가워요, Heon Ha")
                            .font(.custom(.sfProMedium, size: 17))
                        Text("오늘도 화이팅 해볼까요?")
                            .font(.custom(.sfProBold, size: 20))
                    }
                    
                    Spacer()
                    
                    Image(.avatar)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding()
                }
                .padding(.horizontal)
                .frame(height: 120)
            }
        }

    }
    
}

#Preview {
    HomeView()
}
