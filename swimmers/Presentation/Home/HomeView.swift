//
//  HomeView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
        mainBody
            .ignoresSafeArea(edges: .bottom)
            .background(ThemeColor.primary)
        }
    }
    
}

extension HomeView {
    
    private var mainBody: some View {
            
            VStack {
                profileView()
                    .frame(height: 100)
                    .padding(.horizontal, 24)
                    .background(ThemeColor.primary)

                recordView()
                
            }
            .background(ThemeColor.primary)
    }
    
    private func tripleRecordView() -> some View {
        
        HStack {
            recordsCell(.swim, score: 1240)
            recordsCell(.kcal, score: 2330)
            recordsCell(.lap, score: 50)
        }
    }
    
    private func smallRecordCell(title: String, symbolName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(ThemeColor.cellBackground)
                .frame(height: 75)
            HStack {
                Image(systemName: "figure.pool.swim")
                    .font(.system(size: 36))
                Text("자유형")
                    .font(.custom(.godoB, size: 22))
            }
            .foregroundColor(Color.init(hex: "2752EE"))
        }
    }
    
    private func recordView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
            
            VStack {
                mySwimCenter()
    
                tripleRecordView()
                
                weeklyRecords()
                
                HStack {
                    smallRecordCell(title: "자유형", symbolName: "figure.pool.swim")
                    smallRecordCell(title: "23km/h", symbolName: "water.waves")
                }
                
                Spacer()
            }
            .padding([.horizontal, .top], 14)
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
                    
                    HStack(spacing: 10) {
                        DailyRecordBar(day: .sun, score: 10)
                        DailyRecordBar(day: .mon, score: 21)
                        DailyRecordBar(day: .tue, score: 45)
                        DailyRecordBar(day: .wed, score: 90, isPressed: true)
                        DailyRecordBar(day: .thu, score: 76)
                        DailyRecordBar(day: .fri, score: 65)
                        DailyRecordBar(day: .sat, score: 32)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding()
        }
        .frame(height: 200)

    }
    
    private func recordsCell(_ type: RecordCellType, score: Int) -> some View {
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
 
                    Text("\(score)")
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
                MySwimmingPoolView()
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
