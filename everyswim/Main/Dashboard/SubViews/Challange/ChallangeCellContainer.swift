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
    
    var countCell: ChallangeBar?
    var distanceCell: ChallangeBar?
    var lapCell: ChallangeBar?
    
    private let titleLabel: UILabel = {
        let title: String = "이번 주의 수영"
        let label = ViewFactory
            .label(title)
            .font(.custom(.sfProLight, size: 15))
            .foregroundColor(.gray)
        
        return label
    }()
    
    lazy var cellVStack: UIStackView = {
        let vstack = ViewFactory
            .vStack(spacing: 8,
                    alignment: .center,
                    distribution: .fillEqually)
        
        return vstack
    }()
    
    lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([titleLabel, cellVStack])
    
    init() {
        super.init(frame: .zero)
        layout()
        loadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChallangeCellContainer {
    
    func startCircleAnimation() {
        [countCell, distanceCell, lapCell]
            .forEach { view in
                view?.circle.startCircleAnimation()
            }
    }
    
    private func loadData() {
        let goal = UserData.shared.goal
        let weeklyData = SwimDataStore.shared.getWeeklyData()

        let distanceData = weeklyData
            .compactMap { $0.unwrappedDistance }
            .reduce(Double(0)) { $0 + $1 }
        
        let laps = weeklyData
            .compactMap { $0.laps.count }
            .reduce(Double(0)) { $0 + Double($1) }
        
        let counts = Double(weeklyData.count)
        
        let distance = RingViewModel(type: .distance, count: distanceData, maxCount: Double(goal.distancePerWeek))
        let lap = RingViewModel(type: .lap, count: laps, maxCount: Double(goal.lapTimePerWeek))
        let count = RingViewModel(type: .countPerWeek, count: counts, maxCount: Double(goal.countPerWeek))
        
        distanceCell = .init(data: distance)
        distanceCell?.id = "distance"

        lapCell = .init(data: lap)
        lapCell?.id = "lap"

        countCell = .init(data: count)
        countCell?.id = "count"

        self.cellVStack.addArrangedSubview(self.distanceCell!)
        self.cellVStack.addArrangedSubview(self.lapCell!)
        self.cellVStack.addArrangedSubview(self.countCell!)

        distanceCell?.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(cellVStack)
        }
        
        lapCell?.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(cellVStack)
        }
        
        countCell?.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(cellVStack)
        }

    }
    
    func updateRings() {
        let goal = UserData.shared.goal
        let weeklyData = SwimDataStore.shared.getWeeklyData()

        #if DEBUG && targetEnvironment(simulator)
        let distanceData = weeklyData
            .compactMap { $0.unwrappedDistance }
            .reduce(Double(300)) { $0 + $1 }
        
        let laps = weeklyData
            .compactMap { $0.laps.count }
            .reduce(Double(20)) { $0 + Double($1) }
        
        let counts = Double(weeklyData.count + 2)
        #else
        let distanceData = weeklyData
            .compactMap { $0.unwrappedDistance }
            .reduce(Double(0)) { $0 + $1 }
        
        let laps = weeklyData
            .compactMap { $0.laps.count }
            .reduce(Double(0)) { $0 + Double($1) }
        
        let counts = Double(weeklyData.count)
        #endif
        
        let distance = RingViewModel(type: .distance, count: distanceData, maxCount: Double(goal.distancePerWeek))
        let lap = RingViewModel(type: .lap, count: laps, maxCount: Double(goal.lapTimePerWeek))
        let count = RingViewModel(type: .countPerWeek, count: counts, maxCount: Double(goal.countPerWeek))
        
        guard let distanceCell = self.cellVStack.arrangedSubviews
            .first { view in
                view.id == "distance"
            } as? ChallangeBar else {return}
        
        guard let lapCell = self.cellVStack.arrangedSubviews
            .first { view in
                view.id == "lap"
            } as? ChallangeBar else {return}

        guard let countsCell = self.cellVStack.arrangedSubviews
            .first { view in
                view.id == "count"
            } as? ChallangeBar else {return}

        distanceCell.setData(distance)
        lapCell.setData(lap)
        countsCell.setData(count)
        startCircleAnimation()
    }
    
    private func layout() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(mainVStack)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        mainVStack.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.horizontalEdges.equalTo(mainVStack)
        }
        
        cellVStack.snp.makeConstraints { make in
            make.width.equalTo(mainVStack)
            make.height.equalTo(195)
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
        .frame(height: 200)
    }
}
#endif
