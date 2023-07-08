//
//  MyInfoView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct MyInfoView: View {
    
    @State private var showModal = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    header()
                        .padding(8)
                    
                    profileView()
                }
                .frame(height: 166)
                
                ScrollView(showsIndicators: false) {
                    navigationButtons
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .background(BackgroundObject())
        }
    }
    
    private var navigationButtons: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
            
            VStack(spacing: 16) {
                // List A - 회원정보 변경 / 목표 수정 / 알림 설정 / 건강정보 연동 (워치)
                navigationLinkButton(.changeUserInfo)
                navigationLinkButton(.editChallange)
                navigationLinkButton(.setupAlert)
                modalSheetButton(.syncHealth)
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
    
    private func infoButtonStyle(_ type: MyInfoButtonType) -> some View {
        let data = type.getUIData()
        
        return ZStack {
            CellBackground()
            
            HStack {
                Image(systemName: data.symbolName)
                    .font(.system(size: 16))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
                
                Text(data.title)
                    .font(.custom(.sfProLight, size: 16))
                    .foregroundColor(.init(uiColor: .label))

                Spacer()
            }
            .padding(.horizontal, 12)
            
        }
    }
    
    
    private func modalSheetButton(_ type: MyInfoButtonType) -> some View {
        Button {
            showModal.toggle()
        } label: {
            infoButtonStyle(type)
        }
        .frame(height: 50)
        .padding(.horizontal, 12)
        .sheet(isPresented: $showModal) {
            type.destination()
            
        }
    }
    
    private func navigationLinkButton(_ type: MyInfoButtonType) -> some View {
        NavigationLink {
            type.destination()
        } label: {
            infoButtonStyle(type)
        }
        .frame(height: 50)
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
                .foregroundColor(.init(uiColor: .label))
                .lineLimit(1)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                
                Text("heonha@heon.dev")
                    .font(.custom(.sfProLight, size: 15))
                    .foregroundColor(.init(uiColor: .secondaryLabel))
            }
            .frame(width: 187, height: 24)
            
            
        }
    }
    
    private func header() -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.regularMaterial)

                Text("수력 4년차")
                    .font(.custom(.sfProBold, size: 14))
                    .foregroundColor(.init(uiColor: .label))
            }
            .frame(width: 74, height: 36)
            
            Spacer()
            
            Button {
                print("프로필편집")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
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
