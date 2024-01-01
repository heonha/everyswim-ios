//
//  BarChallengeCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/5/23.
//

import UIKit
import SnapKit

final class ChallangeBar: UIView {

    private var data: RingViewModel
    
    private let shadowView = UIView()
    private let backgroundView = UIView()
    private let circleSize: CGFloat = 48
    
    lazy var title = ViewFactory
        .label(data.type.title)
        .font(.custom(.sfProLight, size: 15))
        .textAlignemnt(.left)
        .foregroundColor(.gray)
        .contentHuggingPriority(.init(rawValue: 251), for: .horizontal)

    lazy var countText = ViewFactory
        .label("\(data.progressLabel()) \(data.unit)")
        .font(.custom(.sfProMedium, size: 16))
        .textAlignemnt(.left)
        .contentHuggingPriority(.init(rawValue: 249), for: .horizontal) as! UILabel
    
    private lazy var textHStack = ViewFactory.hStack()
        .addSubviews([title, countText])
        .alignment(.center)
    
    lazy var circle = AnimateRing(data: data, circleSize: circleSize)
        .contentHuggingPriority(.init(rawValue: 251), for: .horizontal) as! AnimateRing
    
    lazy var contentHStack = ViewFactory
        .hStack(subviews: [textHStack, circle],
                spacing: 4,
                alignment: .center)
        .distribution(.fillProportionally)
    
    init(data: RingViewModel) {
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

// MARK: - Configure (set Data)
extension ChallangeBar {
    
    func setData(_ data: RingViewModel) {
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
        circle.updateProgressCircle(data: data)
    }
    
}

extension ChallangeBar {
    // MARK: - Layouts
    private func layout() {
        
        shadowView.layer.cornerRadius = 8
        shadowView.layer.setFigmaShadow(color: .black, alpha: 0.2, x: 0, y: 0, blur: 2, spread: 0, radius: 8)
        self.addSubview(shadowView)
        self.addSubview(backgroundView)

        shadowView.backgroundColor = .systemBackground
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(2)
        }
        backgroundView.backgroundColor = .clear
        backgroundView.addSubview(contentHStack)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(3)
        }
        
        title.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        textHStack.snp.makeConstraints { make in
            make.top.bottom.equalTo(backgroundView)
            make.leading.equalTo(backgroundView).inset(10)
        }
        
        circle.snp.makeConstraints { make in
            make.size.equalTo(circleSize)
            make.trailing.equalTo(backgroundView).inset(10)
        }

        contentHStack.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView)
        }
        
    }

}

#if DEBUG
import SwiftUI

struct BarChallangeCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            ChallangeBar(data: RingViewModel.examples.first!)
        }
        .padding(.horizontal)
        .frame(height: 65)
    }
}
#endif
