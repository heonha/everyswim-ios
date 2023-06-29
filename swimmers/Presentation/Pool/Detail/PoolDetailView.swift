//
//  PoolDetailView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

struct PoolDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        mainBody
            .frame(width: Constant.deviceSize.width)
    }
}

extension PoolDetailView {
    
    var mainBody: some View {
        VStack(spacing: 0) {
            topBar()
                .padding(.horizontal, 8)
            
            Image("pool1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .padding(.bottom, -40)
            
            VStack(spacing: -8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(height: 28)

                ScrollView(.vertical, showsIndicators: false) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                    
                    Group {
                        VStack {
                            // 수영장 이름, 현위치에서의 거리
                            HStack {
                                Text("구로 50플러스 수영장")
                                    .font(.custom(.sfProBold, size: 22))
                                    .foregroundColor(.black)
                                Spacer()
                                Text("500m")
                                    .font(.custom(.sfProMedium, size: 12))
                                    .foregroundColor(.black.opacity(0.38))
                            }
                            .padding(.top, 14)
                            
                            // 주소
                            addressView()
                            
                            Divider()
                            
                            // 레인
                            HStack {
                                Spacer()
                                
                                Text("25 m")
                                
                                Text("5 레인")
                            }
                            .font(.custom(.sfProBold, size: 14))
                            .foregroundColor(Color(hex: "878787"))
                            
                            
                            
                            // 리뷰
                            reviewContainerView()
                            
                            // 영업시간
                            workingTimesView()
                            
                            
                            // 위치 (지도)
                            poolMapView()
                                .frame(height: 190)
                            
                            // 홈페이지 이동
                            contactButtonsView()
                                .frame(height: 52)
                            
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    
                }
                .background(Color.white)
            }
        }
    }
    
    private func workingTimesView() -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("영업시간")
                        .foregroundColor(ThemeColor.grayTint)
                        .font(.custom(.sfProBold, size: 17))
                    Spacer()
                    
                    Text("정보수정요청")
                        .foregroundColor(ThemeColor.grayTint)
                        .font(.custom(.sfProMedium, size: 14))
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ThemeColor.cellBackground)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("평일")
                                .font(.custom(.sfProBold, size: 14))
                            .frame(width: 70)
                            
                            Text("00:00 ~ 00:00")
                                .font(.custom(.sfProLight, size: 14))
                        }
                        
                        HStack {
                            Text("토요일")
                                .font(.custom(.sfProBold, size: 14))
                            .frame(width: 70)
                            
                            Text("00:00 ~ 00:00")
                                .font(.custom(.sfProLight, size: 14))
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("평일")
                                .font(.custom(.sfProBold, size: 14))
                            .frame(width: 70)
                            
                            Text("휴무")
                                .font(.custom(.sfProLight, size: 14))
                        }
                    }
                    .padding(8)
                }
            }
            
        }
    }
    
    private func reviewContainerView() -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                
                HStack(alignment: .center, spacing: 4) {
                    Text("리뷰")
                        .foregroundColor(ThemeColor.grayTint)
                        .font(.custom(.sfProBold, size: 17))
                    
                    Text("(1,234)")
                        .foregroundColor(ThemeColor.grayTint)
                        .font(.custom(.sfProMedium, size: 12))
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ThemeColor.cellBackground)
                    
                    VStack(alignment: .leading) {
                        commentView(userName: "heonha", message: "수영장 깨끗하고 좋아요!")
                        
                        commentView(userName: "apple", message: "다 좋은데 강습 신청하기가 너무 힘들어요 🥲")
                    }
                    .padding(8)
                }
            }
        }
    }

    
    private func commentView(userName: String, message: String) -> some View {
        HStack {
            Text(userName)
                .font(.custom(.sfProBold, size: 14))
                .frame(width: 70)
            
            Text(message)
                .font(.custom(.sfProLight, size: 14))
            
            Spacer()
        }
    }
    
    private func poolMapView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(ThemeColor.cellBackground)
            VStack {
                NaverMapView(userLatitude: 0, userLongitude: 0, isMiniMode: true)
                    .padding(9)
                    .cornerRadius(8)
                
                addressView()
                    .padding(.bottom, 4)
            }
        }
    }
    
    private func addressView() -> some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "3284FE"))
            
            Text("서울특별시 구로구 오류로 36-25 50플러스남부캠퍼스(지하2층)")
                .font(.custom(.sfProMedium, size: 12))
                .foregroundColor(.black.opacity(0.42))
            
            Spacer()
        }
    }
    
    private func contactButtonsView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(ThemeColor.cellBackground)
            
            HStack(spacing: 17) {
                
                externalLinkButton(type: .call) {
                    print("전화하기")
                }
                .padding(.leading, 16)
                
                externalLinkButton(type: .homepage) {
                    print("홈페이지 이동")
                }
                .padding(.trailing, 16)
                
            }
            .frame(height: 38)
            
        }
    }
    
    private func externalLinkButton(type: PoolViewButtonType, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(type.backgroundColor())
                
                HStack {
                    type.symbolImage()
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding(.leading, 6)
                    
                    Spacer()
                    
                    Text(type.title())
                        .foregroundColor(.white)
                        .font(.custom(.sfProBold, size: 18))
                    
                    Spacer()
                }
                
            }
        }
    }
    
    
    private func topBar() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(ThemeColor.grayTint)
                }
                
                Spacer()
                
                Text("구로 50플러스 수영장")
                    .font(.custom(.sfProBold, size: 17))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.red)
                }
            }
        }
        .frame(height: 44)
        
    }
}

extension PoolDetailView {
    
    private enum PoolViewButtonType: String {
        case call
        case homepage
        
        func backgroundColor() -> Color {
            switch self {
            case .call:
                return Color(hex: "2ED91F")
            case .homepage:
                return Color(hex: "2852EE")
            }
        }
        
        func symbolImage() -> Image {
            switch self {
            case .call:
                return Image(systemName: "phone.fill")
            case .homepage:
                return Image(systemName: "network")
            }
        }
        
        func title() -> String {
            switch self {
            case .call:
                return "전화하기"
            case .homepage:
                return "홈페이지"
            }
        }
        
    }
    
    
}


struct PoolDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PoolDetailView()
    }
}
