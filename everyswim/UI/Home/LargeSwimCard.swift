//
//  LargeSwimCard.swift
//  everyswim
//
//  Created by HeonJin Ha on 3/17/24.
//

import Foundation
import SwiftUI

struct LargeSwimCard: View {
    
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(.sfProBold, size: 20))
                .foregroundStyle(Color.white.opacity(0.8))

            contentView()
        }
        .padding(.horizontal, 14)

    }
    
}

extension LargeSwimCard {
    
    // MARK: 오늘의 수영 컨텐츠뷰
    private func contentView() -> some View {
        Group {
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Material.ultraThinMaterial)

                        ZStack {
                            HStack {
                                // Left
                                // 미터, 이미지
                                metersValueView()
                                
                                // Right
                                // 우측 시간, 랩, 페이스 칼로리 뷰
                                VStack(spacing: 4) {
                                    inCardRecord(title: "시간", record: "1:20:35")
                                    inCardRecord(title: "랩", record: "25")
                                    inCardRecord(title: "페이스", record: "1'22''/25m")
                                    inCardRecord(title: "칼로리", record: "1,250 kcal")
                                }
                                .frame(width: (geometry.size.width / 1.8) - 40)
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 18)

                    }
            }
            .frame(height: 160)
        }
    }

    private func metersValueView() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .trailing, spacing: -4) {
                Text("1,500")
                    .font(.custom(.sfProBold, size: 44))
                Text("Meters")
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundStyle(Color.secondary)

            }
            
            Spacer()
            
            Image(.figurePoolSwim)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
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
                        horizontalInCard(title, value: record, geometry: geometry)
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
                    .foregroundStyle(Color.secondary)
                    .frame(width: geometry.size.width / 2.5)
                
                HStack(alignment: .center) {
                    Spacer()
                    Text(value)
                        .font(.custom(.sfProBold, size: 14))
                        .foregroundStyle(AppColor.labelTint)
                    Spacer()
                }

            }
        }
    }

}

#Preview {
    LargeSwimCard(title: "오늘의 수영")
}

#Preview {
    HomeView()
}
