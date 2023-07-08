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
        HStack(spacing: 30) {
            detailStack
            
            progressRing
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(CellBackground())
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

struct ChallangeProgressCircle_Previews: PreviewProvider {
    
    static let rings = [
        ChallangeRing(type: .distance, count: 1680, maxCount: 2000),
        ChallangeRing(type: .lap, count: 45, maxCount: 60),
        ChallangeRing(type: .countPerWeek, count: 2, maxCount: 3)
    ]
    
    static var previews: some View {
        ChallangeRingView(rings: .constant(rings))
    }
}

struct AnimatedRingView: View {
    
    var ring: ChallangeRing
    var index: Int
    var lineWidth: CGFloat = 12
    var linePadding: CGFloat = 16
    
    @State var showRing = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .fill(Color.gray.opacity(0.16))
            
            withAnimation {
                Circle()
                    .trim(from: 0, to: showRing ? ring.progress() : 0.001)
                    .stroke(style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .foregroundColor(ring.keyColor)
                    .rotationEffect(.init(degrees: -90))
            }
            
        }
        .padding(CGFloat(index) * linePadding)
        .opacity(0.9)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(Double(index) * 0.1)) {
                    showRing = true
                }
            }
        }
    }
    
}
