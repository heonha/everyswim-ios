//
//  AnimatedRingView.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

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

struct AnimatedRingView_Previews: PreviewProvider {
    
    static let index: Int = 0
    
    static var previews: some View {
        AnimatedRingView(ring: TestObjects.rings[index], index: index)
    }
}
