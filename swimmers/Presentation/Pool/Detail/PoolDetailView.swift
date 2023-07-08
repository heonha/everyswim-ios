//
//  PoolDetailView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

struct PoolDetailView: View {
    
    
    @State var test = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        mainBody
            .ignoresSafeArea()
    }
}

extension PoolDetailView {
    
    var mainBody: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Image("pool1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Constant.deviceSize.width, height: 300)
                .overlay(alignment: .topTrailing, content: closeButton)
            informationView()
        }
    }
    
    private func closeButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.square.fill")
                .font(.system(size: 30))
                .foregroundColor(.init(uiColor: .systemBackground).opacity(0.8))
                .shadow(color: .black.opacity(0.2),
                        radius: 1,
                        x: 1,
                        y: 1)
        }
        .padding(.top, 44 + 16)
        .padding(.trailing, 20)
    }
    
    private func informationView() -> some View {
        VStack(spacing: -8) {
            Group {
                VStack {
                    // 수영장 이름, 현위치에서의 거리
                    HStack {
                        Text("구로 50플러스 수영장")
                            .font(.custom(.sfProBold, size: 22))
                            .foregroundColor(.init(uiColor: .label))
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.init(uiColor: .systemRed))
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.top, 14)
                    .padding(.bottom, 2)
                    
                    // 주소
                    addressView()
                    
                    Divider()
                    
                    Group {
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
                            .padding(.bottom, 8)
                        
                        // 영업시간
                        workingTimesView()
                            .padding(.vertical, 8)
                        
                        
                        // 홈페이지 이동
                        contactButtonsView()
                            .frame(height: 52)
                            .padding(.vertical, 8)
                        
                        // 위치 (지도)
                        poolMapView()
                            .frame(height: 190)
                            .padding(.vertical, 8)
                        
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            
            .background(BackgroundObject())
        }
        .cornerRadius(8)
    }
    
    private func workingTimesView() -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("영업시간")
                        .foregroundColor(AppColor.grayTint)
                        .font(.custom(.sfProBold, size: 17))
                    Spacer()
                    
                    Text("정보수정요청")
                        .foregroundColor(AppColor.grayTint)
                        .font(.custom(.sfProMedium, size: 14))
                }
                
                ZStack {
                    CellBackground(cornerRadius: 8)
                    
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
                .foregroundColor(.init(uiColor: .label))

            }
            
        }
    }
    
    private func reviewContainerView() -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                
                HStack(alignment: .center, spacing: 4) {
                    Text("리뷰")
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                        .font(.custom(.sfProBold, size: 17))
                    
                    Text("(1,234)")
                        .foregroundColor(.init(uiColor: .tertiaryLabel))
                        .font(.custom(.sfProMedium, size: 12))
                }
                
                ZStack {
                    CellBackground(cornerRadius: 12)
                    
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
                .fill(AppColor.cellBackground)
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
                .foregroundColor(.init(uiColor: .systemBlue))

            Text("서울특별시 구로구 오류로 36-25 50플러스남부캠퍼스(지하2층)")
                .font(.custom(.sfProMedium, size: 12))
                .foregroundColor(.init(uiColor: .secondaryLabel))

            Spacer()
        }
    }
    
    private func contactButtonsView() -> some View {
        ZStack {
            CellBackground(cornerRadius: 8)

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
            CellBackground(cornerRadius: 8)

            
            Text("구로 50플러스 수영장")
                .font(.custom(.sfProBold, size: 17))
            
        }
        
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
