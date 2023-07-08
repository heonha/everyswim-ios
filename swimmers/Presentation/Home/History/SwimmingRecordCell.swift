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

                profileStack(timeString: data.getWorkoutTime())
                    .frame(minHeight: 30)

                Spacer()
                
                recordTitle("월요일 오전 수영")
                    .frame(minHeight: 30)

                Spacer()
                // 기록
                recordStack
                    .frame(minHeight: 40)
            }
        }
        .padding()
        .overlay(alignment: .trailing, content: rightChevronSymbol)
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
    
    private func recordTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.custom(.sfProBold, size: 18))
                .foregroundColor(.init(uiColor: .label))
            
            Spacer()
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
    
    private func profileStack(timeString: String) -> some View {
        HStack {
            Image("Avatar")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text("Heon Ha")
                    .font(.custom(.sfProBold, size: 15))
                    .foregroundColor(.init(uiColor: .label))
                Text(timeString)
                    .font(.custom(.sfProLight, size: 13))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
            }
            
            Spacer()

            VStack {
                HStack(spacing: 2) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                    Text("서울특별시")
                        .font(.custom(.sfProLight, size: 12))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                }
                
                Spacer()
            }
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
