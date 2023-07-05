//
//  SwimmingRecordCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/05.
//

import SwiftUI

struct SwimmingRecordCell: View {
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading) {
                // 프로필
                // 사진 | 이름 / 시간 <-> 위치

                profileStack()
                    .padding(.bottom, 8)
                
                // 타이틀
                HStack {
                    Text("월요일 오전 수영")
                        .font(.custom(.sfProBold, size: 17))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                Spacer()
                
                
                // 기록
                HStack {
                    
                    Spacer()

                    // 미터
                    HStack(alignment: .bottom) {
                        Text("1,240")
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

                        Text("1시간 41분")
                            .font(.custom(.sfProBold, size: 16))
                            .foregroundColor(.black)
                        
                        Spacer()

                    }
                    
                    Spacer()

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
    
    
    private func profileStack() -> some View {
        HStack {
            Image("Avatar")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text("Heon Ha")
                    .font(.custom(.sfProBold, size: 15))
                    .foregroundColor(.black)
                Text("2023년 06월 05일 오전 08:06")
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
