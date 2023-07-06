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
                    .padding(.bottom, 8)
                
                
                Spacer()
                
                // 기록
                HStack {
                    
                    // 미터
                    HStack(alignment: .bottom) {
                        Text(String(data.distance ?? 0))
                            .font(.custom(.sfProBold, size: 18))
                            .foregroundColor(.black)

                        Text("M")
                            .font(.custom(.sfProBold, size: 14))
                            .foregroundColor(.black.opacity(0.5))
                    }
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 1.5, height: 32)

                    // 페이스
                    HStack(alignment: .bottom) {
                        Spacer()

                        Text("2:15")
                            .font(.custom(.sfProBold, size: 18))
                            .foregroundColor(.black)

                        Text("/25m")
                            .font(.custom(.sfProBold, size: 14))
                            .foregroundColor(.black.opacity(0.5))
                        Spacer()

                    }

                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 1.5, height: 32)

                    // 시간
                    HStack(alignment: .bottom) {
                        Spacer()

                        Text(String(data.getDuration()))
                            .font(.custom(.sfProBold, size: 16))
                            .foregroundColor(.black)
                        
                        Spacer()

                    }
                    

                }
            }
            
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.5))
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 1, y: 1)
    }
    
    private func title(_ title: String) {
        HStack {
            Text(title)
                .font(.custom(.sfProBold, size: 17))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
    
    
    private func profileStack(timeString: String) -> some View {
        HStack {
            Image("Avatar")
                .resizable()
                .frame(width: 40, height: 40)
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
    static var previews: some View {
        SwimmingHistoryView()
    }
}
