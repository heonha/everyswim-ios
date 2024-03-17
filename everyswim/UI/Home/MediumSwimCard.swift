//
//  MediumSwimCard.swift
//  everyswim
//
//  Created by HeonJin Ha on 3/17/24.
//

import SwiftUI

struct MediumSwimCard: View {
    
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(.sfProBold, size: 22))
                .foregroundStyle(Color.white.opacity(0.8))
            weekSwimCardContents()
        }
        .padding(.horizontal, 14)

    }
    
}

extension MediumSwimCard {
    
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
    
    // MARK: 카드 내 우측 보조 기록
    // 시간 랩 페이스 칼로리 등...
    // Vertical, Horizontal로 나뉨
    private func inCardRecord(title: String,
                              record: String,
                              axis: Axis) -> some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    Rectangle().fill(.clear)
                    VStack {
                            verticalInCard(title, value: record, geometry: geometry)
                    }
                }
            }
        }
        
    }
    
    // Horizontal 기록 (작은 카드용)
    private func horizontalInCard(_ title: String, value: String, geometry: GeometryProxy) -> some View {
        ZStack {
            HStack(spacing: 4) {
                Text(title)
                    .font(.custom(.sfProBold, size: 13))
                    .frame(width: geometry.size.width / 2.5)
                
                HStack(alignment: .center) {
                    Spacer()
                    Text(value)
                        .font(.custom(.sfProBold, size: 14))
                    Spacer()
                }

            }
        }
    }

    private func verticalInCard(_ title: String, value: String, geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.custom(.sfProMedium, size: 13))
                .frame(width: .infinity, height: geometry.size.height / 2)
            Text(value)
                .font(.custom(.sfProBold, size: 16))
                .frame(width: .infinity, height: geometry.size.height / 2)
        }
    }

}

#Preview {
    HomeView()
}
