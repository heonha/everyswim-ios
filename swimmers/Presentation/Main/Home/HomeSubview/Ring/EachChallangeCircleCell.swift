//
//  EachChallangeCircleCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

import SwiftUI

struct EachChallangeCircleCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    let ring: ChallangeRing
    
    var body: some View {
        mainBody
    }
    
    var mainBody: some View {
        ZStack {
            CellBackground()
            
            VStack(spacing: 4) {
                
                Spacer()
                
                Text(ring.type.title)
                    .font(.custom(.sfProLight, size: 14))
                    .foregroundColor(.gray)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(ring.progressLabel()) \(ring.unit)")
                        .font(.custom(.sfProMedium, size: 14))
                        .foregroundColor(.init(uiColor: .label))
                        .lineLimit(2)
                }
                .padding(.bottom, 8)
                
                
                AnimatedRingView(ring: ring, index: 0, lineWidth: 6)
                    .frame(width: 40, height: 40)
                    .overlay(alignment: .center) {
                        Text(ring.progressPercentString())
                            .font(.custom(.sfProMedium, size: 12))
                    }
 
                Spacer()
                
            }
        }
        .frame(width: 100, height: 100)
    }
}


#if DEBUG
struct RecordCircleCell_Previews: PreviewProvider {
    
    static var previews: some View {
        HStack {
            ForEach(TestObjects.rings) { ring in
                EachChallangeCircleCell(ring: ring)
            }
        }
    }
    
}
#endif
