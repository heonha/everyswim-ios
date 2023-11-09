//
//  SetGoalView.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/2/23.
//

import UIKit
import SnapKit
import Combine

enum MyGoalType {
    case distance
    case lap
    case swimCount
}

struct GoalPerWeek: Codable {
    var distancePerWeek: Int
    var lapTimePerWeek: Int
    var countPerWeek: Int
}

struct SetGoalText {
    let title: String
    let subtitle: String
    let unit: String
}

final class SetGoalCell: UICollectionViewCell, ReuseableObject, CombineCancellable {
    var cancellables: Set<AnyCancellable> = .init()
    
    static var reuseId: String = "SetGoalCell"
    
    var type: MyGoalType = .distance
    var viewModel: SetGoalViewModel?
    var parent: SetGoalViewController?
    
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
        .setSymbolImage(systemName: "plus.circle.fill", color: AppUIColor.secondaryBlue)
        .setSize(width: 40, height: 40)
    
    private let minusButton = UIImageView()
        .setSymbolImage(systemName: "minus.circle.fill", color: AppUIColor.secondaryBlue)
        .setSize(width: 40, height: 40)

    private let doneButton = ViewFactory.label("완료")
        .font(.custom(.sfProMedium, size: 18))
        .textAlignemnt(.center)
        .foregroundColor(.systemBackground)
        .backgroundColor(AppUIColor.secondaryBlue)
        .cornerRadius(8)
    
    // 버튼 / 데이터 / 버튼
    private lazy var middleHStack = ViewFactory.hStack()
        .addSubviews([minusButton, amountLabel, plusButton])
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
        observe()
    }
    
    private func observe() {
        
        plusButton.gesturePublisher(.tap(.init(target: parent, action: nil)) )
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                print("PLUS")
                guard let viewModel = viewModel else {return}

                switch self.type {
                case .distance:
                    viewModel.distance += 25
                case .lap:
                    viewModel.lap += 1
                case .swimCount:
                    viewModel.count += 1
                }
                
                updateCount()
            }
            .store(in: &cancellables)
        
        minusButton.gesturePublisher(.tap(.init(target: parent, action: nil)))
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                print("MINUS")
                
                guard let viewModel = viewModel else {return}
                
                switch self.type {
                case .distance:
                    if viewModel.distance <= 25 { return }
                    viewModel.distance -= 25
                case .lap:
                    if viewModel.lap <= 1 { return }
                    viewModel.lap -= 1
                case .swimCount:
                    if viewModel.count <= 1 { return }
                    viewModel.count -= 1
                }
                
                updateCount()
            }
            .store(in: &cancellables)
        
        doneButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel?.saveGoal()
                self?.parent?.dismiss(animated: true)
            }
            .store(in: &cancellables)

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
        
        contentView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(vstack)
            make.height.equalTo(46)
            make.bottom.equalTo(self.contentView).inset(50)
        }
        
    }
    
    func setType(_ type: MyGoalType) {
        self.type = type
    }
    
    func updateCell(viewModel: SetGoalViewModel) {
        // Labels
        let viewData = viewModel.getTitles(self.type)
        titleLabel.text = viewData.title
        subtitleLabel.text = viewData.subtitle
        unitLabel.text = viewData.unit
        
        // Count
        let currentGoal = viewModel.getCurrentData()
        amountLabel.text = "\(setAmount(from: currentGoal))"
    }
    
    func updateCount() {
        guard let viewModel = viewModel else {return}
        
        switch type {
        case .distance:
            self.amountLabel.text = viewModel.distance.description
        case .lap:
            self.amountLabel.text = viewModel.lap.description
        case .swimCount:
            self.amountLabel.text = viewModel.count.description
        }
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

