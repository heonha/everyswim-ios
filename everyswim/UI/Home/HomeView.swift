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
                
                MediumSwimCard(title: "오늘의 수영")

                LargeSwimCard(title: "이번주 수영")
                
                Spacer()
            }
            
        }
        .ignoresSafeArea(edges: .top)
        
    }
    
}

extension HomeView {
    
    // MARK: - 상단 "안녕하세요, 프로필" 뷰
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
