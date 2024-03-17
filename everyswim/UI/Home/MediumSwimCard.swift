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
                .font(.custom(.sfProBold, size: 20))
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
                        LinearGradient(colors: AppColor.Gradient.first,
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

                                HStack(spacing: 4) {
                                    VStack(alignment: .center, spacing: 12) {
                                        inCardRecord(title: "시간", record: "1:20:35")

                                        inCardRecord(title: "랩", record: "25")
                                    }
                                    
                                    VStack(spacing: 12) {
                                        inCardRecord(title: "페이스", record: "1'22''/25m")
                                        
                                        inCardRecord(title: "칼로리", record: "1,250 kcal")
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
                              record: String) -> some View {
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

    private func verticalInCard(_ title: String, 
                                value: String,
                                geometry: GeometryProxy) -> some View {
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
    MediumSwimCard(title: "이번 주 수영")
}
