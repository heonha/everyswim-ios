//
//  SwimmingRecordCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/05.
//

import SwiftUI

struct SwimmingRecordCell: View {
    
    private let data: SwimmingData
    
    init(data: SwimmingData) {
        self.data = data
    }
    
    var body: some View {
        ZStack {
            VStack {

                HStack {
                    profileStack()
                        .frame(minHeight: 30)

                    Spacer()
                    
                    recordTitle(date: data.getDate(), time: data.getDurationTime())
                        .frame(minHeight: 30)
                }


                Spacer()
                // 기록
                recordStack
                    .frame(minHeight: 40)
            }
        }
        .padding()
//        .overlay(alignment: .trailing, content: rightChevronSymbol)
        .background(CellBackground(cornerRadius: 8))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 1, y: 1)
    }
    
    private func rightChevronSymbol() -> some View {
        Image("chevron.right")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.init(uiColor: .secondaryLabel))
            .frame(width: 14, height: 14)
            .padding(.trailing)
    }
    
    private func recordTitle(date: String, time: String) -> some View {
        HStack {
            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(date)
                    .font(.custom(.sfProMedium, size: 18))
                    .foregroundColor(.init(uiColor: .label))
                
                Text(time)
                    .font(.custom(.sfProMedium, size: 15))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                
                locationLabel()
                
            }

        }
    }
    
    private func recordView(title: String, titleSize: CGFloat = 20, unit: String = "") -> some View {
        HStack(alignment: .bottom) {
            Text(title)
                .font(.custom(.sfProBold, size: titleSize))
                .foregroundColor(.init(uiColor: .label))

            Text(unit)
                .font(.custom(.sfProBold, size: 16))
                .foregroundColor(.init(uiColor: .secondaryLabel))
            
        }
    }
    
    private var recordStack: some View {
        HStack {
            // 미터
            recordView(title: data.getDistance(), unit: "m")
                .frame(maxWidth: 90)

            Divider()
            
            // 페이스
            recordView(title: data.getTotalKcal(), unit: "kcal")
                .frame(maxWidth: 150)

            Divider()

            // 시간
            recordView(title: data.getDuration(), titleSize: 16)
                .frame(maxWidth: 90)

        }
    }
        
    private func profileStack() -> some View {
        VStack(spacing: 4) {
            Image("Avatar")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Heon Ha")
                    .font(.custom(.sfProBold, size: 15))
                    .foregroundColor(.init(uiColor: .label))
            }
        }
    }
    
    private func locationLabel() -> some View {
        HStack(spacing: 2) {
            Image(systemName: "location.fill")
                .font(.system(size: 12))
                .foregroundColor(.init(uiColor: .secondaryLabel))
            
            Text("서울특별시")
                .font(.custom(.sfProLight, size: 12))
                .foregroundColor(.init(uiColor: .secondaryLabel))
        }
    }
}

struct SwimmingRecordCell_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach(TestObjects.swimmingData) { data in
                    SwimmingRecordCell(data: data)
                        .padding(.horizontal, 21)
                }
            }
        }
    }
}
