//
//  RecentHistoryCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct RecentHistoryCell: View {
    
    let destination: AnyView
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            ZStack {
                
                HStack(spacing: 30) {
                    Text("1,100 M")
                        .font(.custom(.sfProBold, size: 24))
                        .foregroundColor(.init(uiColor: .label))
                    
                    Text("30 Lap")
                        .font(.custom(.sfProBold, size: 21))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                }
                
                HStack {
                    Spacer()
                    
                    Text("3일 전")
                        .font(.custom(.sfProLight, size: 12))
                        .foregroundColor(.init(uiColor: .secondaryLabel))

                    Image(systemName: "chevron.right")
                        .font(.custom(.sfProBold, size: 14))
                        .foregroundColor(.init(uiColor: .secondaryLabel))

                    Rectangle()
                        .fill(.clear)
                        .frame(width: 4)
                }
            }
            .background(CellBackground(cornerRadius: 16))
            .frame(height: 48)
        }
    }
    
}
