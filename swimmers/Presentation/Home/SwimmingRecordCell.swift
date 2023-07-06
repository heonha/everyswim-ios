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
            
            rightChevronSymbol
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 1, y: 1)
    }
    
    private var rightChevronSymbol: some View {
        HStack {
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.5))
        }
    }
    
    private func recordTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.custom(.sfProBold, size: 18))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
    
    private var recordStack: some View {
        HStack {

            // 미터
            HStack {
                Text(String(data.getDistance()))
                    .font(.custom(.sfProBold, size: 20))
                    .foregroundColor(.black)

                Text("M")
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundColor(.black.opacity(0.5))
            }
            .frame(maxWidth: 100)
  
            Divider()
            
            // 페이스
            HStack(alignment: .bottom) {
                Text(data.getTotalKcal())
                    .font(.custom(.sfProBold, size: 20))
                    .foregroundColor(.black)

                Text("kcal")
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundColor(.black.opacity(0.5))
            }
            .frame(maxWidth: 100)

            Divider()

            // 시간
            HStack {
                Text(String(data.getDuration()))
                    .font(.custom(.sfProBold, size: 16))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: 100)


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
                    .foregroundColor(.black)
                Text(timeString)
                    .font(.custom(.sfProLight, size: 13))
                    .foregroundColor(.black.opacity(0.5))
            }
            
            Spacer()

            VStack {
                HStack(spacing: 2) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.5))
                    Text("서울특별시")
                        .font(.custom(.sfProLight, size: 12))
                        .foregroundColor(.black.opacity(0.5))
                }
                
                Spacer()
            }
        }
    }
}

struct SwimmingRecordCell_Previews: PreviewProvider {
    
    static let swimmingData = [
        SwimmingData(id: UUID(), duration: 6503, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460),
        SwimmingData(id: UUID(), duration: 1234, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460),
        SwimmingData(id: UUID(), duration: 4567, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460),
        SwimmingData(id: UUID(), duration: 10, startDate: Date(), endDate: Date(), distance: 500, activeKcal: 1000, restKcal: 500, stroke: 460)
    ]
    
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach(swimmingData) { data in
                    SwimmingRecordCell(data: data)
                        .padding(.horizontal, 21)
                }
            }
        }

    }
}
