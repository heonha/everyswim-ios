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
            
            HStack {
                Image(ring.keyIcon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ring.keyColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor(ring.keyColor)
                
                    .padding(.leading)
                
                HStack(alignment: .bottom) {
                    Text(ring.progressLabel())
                        .font(.custom(.sfProBold, size: 24))
                        .foregroundColor(.init(uiColor: .label))

                    Text(ring.unit)
                        .font(.custom(.sfProBold, size: 16))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
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


#if DEBUG
struct RecordCircleCell_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            ForEach(TestObjects.rings) { ring in
                EachChallangeCircleCell(ring: ring)
                    .padding(.horizontal)
            }
        }
    }
    
}
#endif
