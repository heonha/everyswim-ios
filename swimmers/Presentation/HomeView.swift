//
//  HomeView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                profileView()
                    .frame(height: 100)
                    .padding(.horizontal, 14)

                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                    
                    VStack {

                        mySwimCenter()
                        
                        Spacer()
                        
                    }
                    .padding([.horizontal, .top], 14)
                    
                }
                
                
            }
            .ignoresSafeArea(edges: .bottom)
            
        }
        .background(ThemeColor.primary)
    }
    
    
    func profileView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Heon Ha")
                Text("이번주에는 모든 목표를 달성했어요!🔥")
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            
            Spacer()
            
            Image("user")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
    
    func mySwimCenter() -> some View {
        Group {
            NavigationLink {
                MySwimCenterView()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ThemeColor.cellBackground)
                        .frame(height: 47)
                    
                    HStack {
                        Image(systemName: "mappin.circle")
                            .resizable()
                            .frame(width: 21, height: 21)
                            .foregroundColor(ThemeColor.grayTint)
                            .padding(.leading)
                        
                        Text("나의 수영장")
                            .font(.system(size: 14))
                            .foregroundColor(ThemeColor.grayTint)
                        
                        
                        Text("구로 50 플러스 수영장")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(ThemeColor.grayTint)
                            .padding(.trailing)
                    }
                }
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
