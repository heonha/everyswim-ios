//
//  ChallangeCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/7/23.
//

import UIKit
import SnapKit

final class ChallangeCell: UIView {
    
    private let data: ChallangeRing
    
    private let backgroundView = UICellBackground()
    
    lazy var title = ViewFactory
        .label(data.type.title)
        .font(.custom(.sfProLight, size: 14))
        .foregroundColor(.gray)

    lazy var countText = ViewFactory
        .label(data.progressLabel())
        .font(.custom(.sfProMedium, size: 14))
    
    lazy var circle = AnimateRingUIView(data: data, 
                                        circleSize: 40)
    
    lazy var vstack = ViewFactory
        .vStack(subviews: [title, countText, circle],
                spacing: 4,
                alignment: .center)
        .setSpacing(6)

    
    init(data: ChallangeRing, index: Int) {
        self.data = data
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension ChallangeCell {

    func layout() {
        self.addSubview(backgroundView)

        self.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(vstack)
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
