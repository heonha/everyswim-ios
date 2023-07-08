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
        HStack(spacing: 20) {
            progressRing
            
            detailStack
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
    }
    
    private var detailStack: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(rings) { ring in
                    Label {
                        HStack(alignment: .bottom, spacing: 2) {
                            Text(ring.progressLabel())
                                .font(.custom(.sfProBold, size: 20))
                                .foregroundColor(ring.keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.3, x: 0.5, y: 0.5)

                            Text("\(ring.unit)")
                                .font(.custom(.sfProBold, size: 14))
                                .foregroundColor(.black.opacity(0.5))
                                .padding(.trailing, 6)
                        }
                    } icon: {
                        Group {
                            Image(systemName: ring.keyIcon)
                                .font(.title3)
                        }
                        .frame(width: 40)
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
    @State var showRing = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .fill(Color.gray.opacity(0.3))

            withAnimation {
                Circle()
                    .trim(from: 0, to: showRing ? ring.progress() : 0.001)
                    .stroke(style: .init(lineWidth: 12, lineCap: .round, lineJoin: .round))
                    .foregroundColor(ring.keyColor)
                    .rotationEffect(.init(degrees: -90))
            }

        }
        .padding(CGFloat(index) * 16)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(Double(index) * 0.1)) {
                    showRing = true
                }
            }
        }
    }
    
}
