//
//  ChallangeCellContainer.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/7/23.
//

import UIKit
import SnapKit

final class ChallangeCellContainer: UIView {
    
    private let backgroundView = UIView()
    
    lazy var cells: [UIView] = [
        ChallangeCell(data: TestObjects.rings[0]),
        ChallangeCell(data: TestObjects.rings[1]),
        ChallangeCell(data: TestObjects.rings[2])
    ]
    
    private let titleLabel: UILabel = {
        let title: String = "누적 기록"
        let label = ViewFactory.label(title)
            .font(.custom(.sfProLight, size: 15))
            .foregroundColor(.gray)
        
        return label
    }()
    
    lazy var hstack: UIStackView = {
        let hstack = ViewFactory
            .hStack(subviews: self.cells, alignment: .center, distribution: .fill)
        return hstack
    }()
    
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChallangeCellContainer {
    
    private func layout() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(hstack)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(backgroundView)
        }
        
        hstack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.centerX.equalTo(backgroundView)
        }
    }
    
}


#if DEBUG
import SwiftUI

struct ChallangeCellContainer_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            ChallangeCellContainer()
        }
        .frame(height: 130)
    }
}
#endif
