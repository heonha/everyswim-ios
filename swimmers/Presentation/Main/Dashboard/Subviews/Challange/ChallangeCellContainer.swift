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
    
    private lazy var countCell = ChallangeCell(data: TestObjects.rings[2])
    private lazy var distanceCell = ChallangeCell(data: TestObjects.rings[0])
    private lazy var lapCell = ChallangeCell(data: TestObjects.rings[1])
    
    private let titleLabel: UILabel = {
        let title: String = "목표 현황(9월 2주)"
        let label = ViewFactory.label(title)
            .font(.custom(.sfProLight, size: 15))
            .foregroundColor(.gray)
        
        return label
    }()
    
    lazy var hstack: UIStackView = {
        let spacing =  ((Constant.deviceSize.width - 40) / 3) * 0.1
        let hstack = ViewFactory
            .hStack(subviews: [distanceCell, lapCell, countCell], 
                    spacing: spacing,
                    alignment: .center,
                    distribution: .fillEqually)
        
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
    
    func startCircleAnimation() {
        [countCell, distanceCell, lapCell]
            .forEach { view in
                view.circle.startCircleAnimation()
            }
    }
    
    private func layout() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(hstack)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(backgroundView)
        }
        
        hstack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(backgroundView).inset(4)
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
