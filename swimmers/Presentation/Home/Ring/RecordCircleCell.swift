//
//  RecordCircleCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct RecordCircleCell: View {
    
    let ring: ChallangeRing
    
    var body: some View {
        mainBody
    }
    
    var mainBody: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.16), radius: 5, x: 1, y: 1)

            HStack {
                Image(systemName: ring.keyIcon)
                    .font(.system(size: 29))
                    .foregroundColor(ring.keyColor)
                    .padding(.leading)
                
                HStack(alignment: .bottom) {
                    Text(ring.progressLabel())
                        .font(.custom(.sfProBold, size: 24))
                        .foregroundColor(.black)

                    Text(ring.unit)
                        .font(.custom(.sfProBold, size: 16))
                        .foregroundColor(.gray)
                        .offset(y: -2)
                }

                Spacer()
                
                AnimatedRingView(ring: ring, index: 0, lineWidth: 6)
                    .frame(width: 40, height: 40)
                    .overlay(alignment: .center) {
                        Text(ring.progressPercentString())
                            .font(.custom(.sfProMedium, size: 12))
                    }
                    .padding(.trailing)
                
            }
        }
        .frame(height: 60)
    }
}

struct RecordCircleCell_Previews: PreviewProvider {
    
    static let rings = [
        ChallangeRing(type: .distance, count: 1680, maxCount: 2000),
        ChallangeRing(type: .lap, count: 45, maxCount: 60),
        ChallangeRing(type: .countPerWeek, count: 2, maxCount: 3)
    ]
    
    
    static var previews: some View {
        
        VStack {
            ForEach(rings) { ring in
                RecordCircleCell(ring: ring)
                    .padding(.horizontal)
            }
        }
        
    }
}
