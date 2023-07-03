//
//  MyInfoView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct MyInfoView: View {
        
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    topBar()
                        .padding(8)
                    
                    profileView()
                    
                }
                .frame(height: 166)
                
                ScrollView(showsIndicators: false) {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                        
                        VStack(spacing: 8) {
                            // List A - 회원정보 변경 / 목표 수정 / 알림 설정 / 건강정보 연동 (워치)
                            navigationLinkButton(.changeUserInfo)
                            navigationLinkButton(.editChallange)
                            navigationLinkButton(.setupAlert)
                            navigationLinkButton(.syncHealth)
                                .padding(.bottom, 32)

                            // List B - 앱 공유하기 / 문의 보내기 / 도움말
                            navigationLinkButton(.shareApp)
                            navigationLinkButton(.sendContact)
                            navigationLinkButton(.questions)
                                .padding(.bottom, 32)
                  
                            // List 3
                            navigationLinkButton(.logout)
                            navigationLinkButton(.deleteAccount)
                        }
                        .padding(.vertical)
                        
                    }
                    .padding(.vertical)

                }
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
    
    private func navigationLinkButton(_ type: MyInfoButtonType) -> some View {
        let data = type.getUIData()
        
        return NavigationLink {
            type.destination()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
                
                HStack {
                    Image(systemName: data.symbolName)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "747474"))
                    
                    Text(data.title)
                        .font(.custom(.sfProLight, size: 16))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                
            }
        }
        .frame(height: 42)
        .padding(.horizontal, 12)
    }
    
    private func profileView() -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(.regularMaterial)
                
                Image("Avatar")
                    .resizable()
                    .foregroundColor(.black)
                    .scaledToFit()
                    .clipShape(Circle())
            }
            .frame(width: 60, height: 60)
            
            Text("Heon Ha")
                .font(.custom(.sfProBold, size: 20))
                .lineLimit(1)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.regularMaterial)
                
                Text("heonha@heon.dev")
                    .tint(Color(hex: "000000").opacity(0.40))
                    .font(.custom(.sfProLight, size: 14))
            }
            .frame(width: 187, height: 24)
            

        }
    }
    
    private func topBar() -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.regularMaterial)
                
                Text("수력 4년차")
                    .font(.custom(.sfProBold, size: 14))
            }
            .frame(width: 74, height: 24)
            
            Spacer()
            
            Button {
                print("프로필편집")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 1)
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "7E7E7E"))
                }
            }
            .frame(width: 20, height: 20)

        }
    }
}

struct MyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoView()
    }
}
