//
//  SyncHealthView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI

struct SyncHealthView: View {
    
    private var hkManager: HealthKitManager = .init()
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image("AppleHealth")
                .resizable()
                .frame(width: 120, height: 120)
                .scaledToFill()
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("Apple 건강에서\n기록 가져오기")
                    .font(.custom(.sfProBold, size: 24))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("기존의 기록을 반영하려면\nApple 건강 데이터를 가져오세요.")
                    .multilineTextAlignment(.center)
                    .font(.custom(.sfProMedium, size: 18))
            }
            
            Spacer()
            
            Button {
//                hkManager.checkAuthorizationStatus()
//                hkManager.checkAuth()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "2752EE"))
                    
                    Text("계속하기")
                        .font(.custom(.sfProBold, size: 18))
                        .foregroundColor(.white)
                }
            }
            .frame(height: 44)

    
        }
        .padding()
    }
}

struct SyncHealthView_Previews: PreviewProvider {
    static var previews: some View {
        SyncHealthView()
    }
}
