//
//  ChallangeCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/7/23.
//

import UIKit
import SnapKit

final class ChallangeCell: UIView {
    
    private var data: ChallangeRing
    
    private let backgroundView = UICellBackground()
    
    lazy var title = ViewFactory
        .label(data.type.title)
        .font(.custom(.sfProLight, size: 14))
        .foregroundColor(.gray)

    lazy var countText = ViewFactory
        .label("\(data.progressLabel()) \(data.unit)")
        .font(.custom(.sfProMedium, size: 14))
    
    lazy var circle = AnimateRingUIView(data: data, 
                                        circleSize: 40)
    
    lazy var vstack = ViewFactory
        .vStack(subviews: [title, countText, circle],
                spacing: 4,
                alignment: .center)
        .setEdgeInset(.all(6))

    init(data: ChallangeRing) {
        self.data = data
        super.init(frame: .zero)
        self.setContentHuggingPriority(.init(251), for: .horizontal)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension ChallangeCell {
    
    func setData(_ data: ChallangeRing) {
        self.data = data
    }

    func layout() {
        self.addSubview(backgroundView)
        
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(100)
            make.height.greaterThanOrEqualTo(100)
        }
        backgroundView.addSubview(vstack)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
            ChallangeCell(data: ChallangeRing.examples.first!)
        }
    }
}
#endif
