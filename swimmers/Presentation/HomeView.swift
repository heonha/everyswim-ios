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
                        
                        HStack {
                            recordsCell(.swim)
                            recordsCell(.kcal)
                            recordsCell(.lap)
                        }
                        
                        
                        Spacer()
                        
                    }
                    .padding([.horizontal, .top], 14)
                    
                }
                
                
            }
            .ignoresSafeArea(edges: .bottom)
            
        }
        .background(ThemeColor.primary)
    }
    
    func recordsCell(_ type: RecordCellType) -> some View {
        Group {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(ThemeColor.cellBackground)
                    .frame(height: 128)
                
                VStack(spacing: 4) {
                    Group {
                        Image(systemName: type.symbolName())
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(type.getSymbolColor())
                    }
                    .frame(width: 50, height: 27)
 
                    
                    Text("1,240")
                        .font(.system(size: 30, weight: .bold))
                    
                    Text(type.getUnit())
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.init(hex: "000000").opacity(0.3))
                }
            }
        }
    }
    
    enum RecordCellType: String {
        
        case swim
        case kcal
        case lap
        
        func symbolName() -> String {
            switch self {
            case .swim:
                return "figure.pool.swim"
            case .kcal:
                return "flame"
            case .lap:
                return "flag.checkered"
            }
        }
        
        func getSymbolColor() -> Color {
            switch self {
            case .swim:
                return ThemeColor.primary
            case .kcal:
                return ThemeColor.caloriesRed
            case .lap:
                return Color.black
            }
        }
        
        func getUnit() -> String {
            switch self {
            case .swim:
                return "Meters"
            case .kcal:
                return "Kcal"
            case .lap:
                return "Lap"
            }
        }
        
        
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
