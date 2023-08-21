//
//  PoolListView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/06/25.
//

import SwiftUI

struct PoolListView: View {
    
    @State private var text = ""
    @State private var showDetail = false
    
    var body: some View {
        NavigationView {
            mainBody()
        }
    }
    
}

extension PoolListView {
    
    private func mainBody() -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.init(uiColor: .systemFill))
                .frame(width: 36, height: 5)
                .padding(.bottom)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    SwimmingPoolCell(pool: ._50plus)
                        .onTapGesture {
                            showDetail.toggle()
                        }
                    
                    SwimmingPoolCell(pool: .gochukdom)
                    
                    SwimmingPoolCell(pool: .guronam)
                }
            }
            Spacer()
        }
        .padding(.all, 14)
        .fullScreenCover(isPresented: $showDetail) {
            PoolDetailView()
        }
        
    }

}

struct SearchPoolView_Previews: PreviewProvider {
    static var previews: some View {
            PoolListView()
    }
}