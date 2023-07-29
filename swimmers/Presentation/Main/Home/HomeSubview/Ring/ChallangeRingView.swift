//
//  ChallangeRingView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct ChallangeRingView: View {
    
    @Binding var rings: [ChallangeRing]
    
    init(rings: Binding<[ChallangeRing]>) {
        _rings = rings
    }
    
    var body: some View {
        ZStack {
            CellBackground()
            
            HStack(spacing: 30) {
                detailStack
                
                progressRing
            }
        }
    }
    
    private var detailStack: some View {
        ZStack {
            VStack(alignment: .center, spacing: 12) {
                Text("78%")
                    .font(.custom(.sfProBold, size: 34))
                    .foregroundColor(.init(uiColor: .label))
                    .shadow(color: .black.opacity(0.4), radius: 0.3, x: 0.5, y: 0.5)
                
                VStack {
                    Text("이번 주")
                        .multilineTextAlignment(.center)
                        .font(.custom(.sfProBold, size: 15))
                        .foregroundColor(Color.init(uiColor: .secondaryLabel))
                        .padding(.trailing, 6)
                    
                    Text("11월 11일 ~ 11월 15일")
                        .multilineTextAlignment(.center)
                        .font(.custom(.sfProBold, size: 15))
                        .foregroundColor(Color.init(uiColor: .secondaryLabel))
                        .padding(.trailing, 6)
                }
            }
        }
    }
    
    private var progressRing: some View {
        ZStack {
            ForEach(rings.indices, id: \.self) { index in
                AnimatedRingView(ring: rings[index], index: index)
            }
        }
        .frame(maxWidth: 130, maxHeight: 130)
    }
    
}

#if DEBUG
struct ChallangeProgressCircle_Previews: PreviewProvider {
    
    static var previews: some View {
        ChallangeRingView(rings: .constant(TestObjects.rings))
            .frame(height: 170)

    }
    
}
#endif
