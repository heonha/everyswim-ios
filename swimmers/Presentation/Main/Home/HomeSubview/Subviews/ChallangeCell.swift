//
//  ChallangeCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/7/23.
//

import UIKit
import SnapKit

final class ChallangeCell: UIView {
    
    let data: ChallangeRing
    let index: Int
    
    init(data: ChallangeRing, index: Int) {
        self.data = data
        self.index = index
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}


//     var mainBody: some View {
//         ZStack {
//             CellBackground()
//             
//             VStack(spacing: 4) {
//                 
//                 Spacer()
//                 
//                 Text(ring.type.title)
//                     .font(.custom(.sfProLight, size: 14))
//                     .foregroundColor(.gray)
//                 
//                 HStack(alignment: .bottom, spacing: 4) {
//                     Text("\(ring.progressLabel()) \(ring.unit)")
//                         .font(.custom(.sfProMedium, size: 14))
//                         .foregroundColor(.init(uiColor: .label))
//                         .lineLimit(2)
//                 }
//                 .padding(.bottom, 8)
//                 
//                 
//                 AnimatedRingView(ring: ring, index: 0, lineWidth: 6)
//                     .frame(width: 40, height: 40)
//                     .overlay(alignment: .center) {
//                         Text(ring.progressPercentString())
//                             .font(.custom(.sfProMedium, size: 12))
//                     }
//  
//                 Spacer()
//                 
//             }
//         }
//         .frame(width: 100, height: 100)
//     }
// }

extension ChallangeCell {
    
    func layout() {
        let title = ViewFactory.label(data.type.title)
        let countText = ViewFactory.label(data.progressLabel())
        countText.insetsLayoutMarginsFromSafeArea = true
        countText.directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 8, trailing: 0)
        let circle = AnimateRingUIView(ring: data, index: index, circleSize: 40)
        
        let vstack = ViewFactory.vStack(subviews: [title, countText, circle],
                                        alignment: .center)
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        self.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


#if DEBUG
import SwiftUI

struct ChallangeCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            ChallangeCell(data: TestObjects.rings.first!, index: 0)
        }
    }
}
#endif
