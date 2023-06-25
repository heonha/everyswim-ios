//
//  HomeView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct HomeView: View {
    
    
    var body: some View {
        mainBody
            .ignoresSafeArea(edges: .bottom)
            .background(ThemeColor.primary)
    }
    
}

extension HomeView {
    
    private var mainBody: some View {
        VStack {
            profileView()
                .frame(height: 100)
                .padding(.horizontal, 24)
            
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
                    
                    weeklyRecords()
                    
                    Spacer()
                }
                .padding([.horizontal, .top], 14)
            }
        }
    }
    
    private func weeklyRecords() -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(ThemeColor.cellBackground)
            
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "timelapse")
                                .resizable()
                                .frame(width: 23, height: 23)
                                .foregroundColor(.init(hex: "0E2FD8").opacity(0.65))
                            Text("주간 기록")
                                .font(.custom(.godoB, size: 16))
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Weekly")
                                .font(.custom(.sfProBold, size: 14))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(ThemeColor.grayTint)
                        .padding(.trailing, 16)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        recordBar(.sun, score: 10)
                        recordBar(.mon, score: 30)
                        recordBar(.tue, score: 20)
                        recordBar(.wed, score: 15, isPressed: true)
                        recordBar(.thu, score: 20)
                        recordBar(.fri, score: 50)
                        recordBar(.sat, score: 10)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding()
        }
        .frame(height: 200)

    }
    
    private func recordBar(_ weekday: Weekdays, score: CGFloat, isPressed: Bool = false) -> some View {
        let color = isPressed ? Color.init(hex: "2752EE") : Color(hex: "000000").opacity(0.1)
        
        return VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
                .frame(height: score)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
            
            Text(weekday.rawValue)
                .font(.custom(.sfProBold, size: 17))
                .foregroundColor(ThemeColor.grayTint)
        }
        
    }
    
    private func recordsCell(_ type: RecordCellType) -> some View {
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
    
    private func mySwimCenter() -> some View {
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
