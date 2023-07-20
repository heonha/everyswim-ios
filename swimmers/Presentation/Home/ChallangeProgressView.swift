//
//  ChallangeProgressView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct ChallangeProgressView: View {
    
    let rings [SwimmingData] = []
    
    var body: some View {

        ZStack {
            HStack(spacing: 20) {
                ForEach(rings.indices, id: \.self) { _ in
                    Circle()
                        .stroke(lineWidth: 10)
                        .fill(Color.gray.opacity(0.3))
                }
            }
            .frame(width: 130, height: 130)
        }
    }
}

struct ChallangeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ChallangeProgressView()
    }
}
