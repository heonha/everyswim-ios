//
//  SetGoalView.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/2/23.
//

import UIKit
import SnapKit

enum MyGoalType {
    case distance
    case lap
    case swimCount
}

struct GoalPerWeek {
    var distancePerWeek: Int
    var lapTimePerWeek: Int
    var countPerWeek: Int
}

struct SetGoalText {
    let title: String
    let subtitle: String
    let unit: String
}

final class SetGoalCell: UICollectionViewCell, ReuseableCell {
    static var reuseId: String = "SetGoalCell"
    
    var type: MyGoalType = .distance
    
    private lazy var mainTitleLabel = ViewFactory.label("주간 수영 목표")
        .font(.custom(.sfProBold, size: 35))
        .textAlignemnt(.center)
   
    
    private var titleLabel = ViewFactory.label("거리")
        .font(.custom(.sfProBold, size: 30))
    
    private var amountLabel = ViewFactory.label("0")
        .font(.custom(.sfProBold, size: 40))
    
    private var unitLabel = ViewFactory.label("미터 / 일")
        .font(.custom(.sfProBold, size: 20))

    private var subtitleLabel = ViewFactory.label("하루에 수영 할 목표 거리를 선택해주세요")
        .font(.custom(.sfProLight, size: 17))
    
    
    private let plusButton = UIImageView()
        .setSymbolImage(systemName: "plus.circle.fill", color: AppUIColor.primaryBlue)
        .setSize(width: 40, height: 40)
    
    private let minusButton = UIImageView()
        .setSymbolImage(systemName: "minus.circle.fill", color: AppUIColor.primaryBlue)
        .setSize(width: 40, height: 40)

    // 버튼 / 데이터 / 버튼
    private lazy var middleHStack = ViewFactory.hStack()
        .addSubviews([plusButton, amountLabel, minusButton])
        .alignment(.center)
        .spacing(48)
    
    private lazy var middleVStack = ViewFactory.vStack()
        .addSubviews([middleHStack, unitLabel])
        .spacing(8)
        .alignment(.center)

    
    private lazy var vstack = ViewFactory.vStack()
        .addSubviews([titleLabel, middleVStack, subtitleLabel])
        .spacing(16)
        .alignment(.center)
        .distribution(.equalSpacing)

    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
        layout()
    }
    
    private func configure() {

    }
    
    private func layout() {
        contentView.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.height.equalTo(contentView).multipliedBy(0.3)
            make.width.equalTo(contentView).multipliedBy(0.8)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(mainTitleLabel)
        mainTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(vstack.snp.top)
            make.height.equalTo(50)
        }
        
    }
    
    func setType(_ type: MyGoalType) {
        self.type = type
    }
    
    func updateCell(viewModel: SetGoalViewModel) {
        let viewData = viewModel.getTitles(self.type)
        titleLabel.text = viewData.title
        subtitleLabel.text = viewData.subtitle
        unitLabel.text = viewData.unit
        let currentGoal = viewModel.getCurrentData()
        amountLabel.text = "\(setAmount(from: currentGoal))"
    }
    
    private func setAmount(from goal: GoalPerWeek) -> Int {
        let count = goal.countPerWeek
        switch type {
        case .distance:
            return goal.distancePerWeek / count
        case .lap:
            return goal.lapTimePerWeek / count
        case .swimCount:
            return count
        }
    }
    
}

#if DEBUG
import SwiftUI

struct SetGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            SetGoalCell()
        }
    }
}
#endif

