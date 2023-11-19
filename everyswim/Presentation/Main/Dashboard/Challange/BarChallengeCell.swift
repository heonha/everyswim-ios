//
//  BarChallengeCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/5/23.
//

import UIKit
import SnapKit

final class BarChallangeCell: UIView {
    
    private var data: ChallangeRing
    
    private let backgroundView = UICellBackground()
    
    lazy var title = ViewFactory
        .label(data.type.title)
        .font(.custom(.sfProLight, size: 14))
        .textAlignemnt(.center)
        .foregroundColor(.gray)
        .contentHuggingPriority(.init(rawValue: 251), for: .horizontal)

    lazy var countText = ViewFactory
        .label("\(data.progressLabel()) \(data.unit)")
        .font(.custom(.sfProMedium, size: 16))
        .contentHuggingPriority(.init(rawValue: 249), for: .horizontal) as! UILabel
    
    lazy var circle = AnimateRingUIView(data: data,
                                        circleSize: 40)
        .contentHuggingPriority(.init(rawValue: 251), for: .horizontal) as! AnimateRingUIView
    
    lazy var vstack = ViewFactory
        .hStack(subviews: [title, countText, circle],
                spacing: 4,
                alignment: .center)
        .distribution(.fillProportionally)
        .setEdgeInset(.init(top: 6, leading: 6, bottom: 6, trailing: 6))

    
    init(data: ChallangeRing) {
        self.data = data
        super.init(frame: .zero)
        self.setContentHuggingPriority(.init(251), for: .horizontal)
        layout()
        setData(data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension BarChallangeCell {
    
    func setData(_ data: ChallangeRing) {
        self.data = data
        let goal = UserData.shared.goal
        var amount: Int = 0
        switch data.type {
        case .distance:
            amount = goal.distancePerWeek
        case .lap:
            amount = goal.lapTimePerWeek
        case .countPerWeek:
            amount = goal.countPerWeek
        default:
            amount = 0
        }
        self.countText.text = "\(data.progressLabel()) / \(amount.description) \(data.unit)"
    }

    func layout() {
        self.addSubview(backgroundView)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(AppConstant.deviceSize.width)
            make.height.equalTo(50)
        }
        backgroundView.addSubview(vstack)
        
        backgroundView.snp.makeConstraints { make in
            make.width.equalTo(AppConstant.deviceSize.width - 20)
            make.centerX.equalTo(self)
        }
        
        circle.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalTo(backgroundView).inset(20)
        }
        
        title.snp.makeConstraints { make in
            make.width.equalTo(60)
        }

        vstack.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView)
        }
    }

}


#if DEBUG
import SwiftUI

struct BarChallangeCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            BarChallangeCell(data: TestObjects.rings.first!)
        }
    }
}
#endif
