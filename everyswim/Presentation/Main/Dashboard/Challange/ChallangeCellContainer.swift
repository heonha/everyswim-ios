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
    
    var countCell: BarChallangeCell?
    var distanceCell: BarChallangeCell?
    var lapCell: BarChallangeCell?
    
    private let titleLabel: UILabel = {
        let title: String = "이번주 현황"
        let label = ViewFactory.label(title)
            .font(.custom(.sfProLight, size: 15))
            .foregroundColor(.gray)
        
        return label
    }()
    
    lazy var hstack: UIStackView = {
        let spacing =  ((AppConstant.deviceSize.width - 40) / 3) * 0.1
        let vstack = ViewFactory
            .vStack(spacing: spacing,
                    alignment: .center,
                    distribution: .fillEqually)
        
        return vstack
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    func loadData() {
        let goal = UserData.shared.goal
        let weeklyData = SwimDataStore.shared.getWeeklyData()

        let distanceData = weeklyData
            .compactMap { $0.unwrappedDistance }
            .reduce(Double(0)) { $0 + $1 }
        
        let laps = weeklyData
            .compactMap { $0.laps.count }
            .reduce(Double(0)) { $0 + Double($1) }
        
        let counts = Double(weeklyData.count)
        
        let distance = ChallangeRing(type: .distance, count: distanceData, maxCount: Double(goal.distancePerWeek))
        let lap = ChallangeRing(type: .lap, count: laps, maxCount: Double(goal.lapTimePerWeek))
        let count = ChallangeRing(type: .countPerWeek, count: counts, maxCount: Double(goal.countPerWeek))

        distanceCell = .init(data: distance)
        lapCell = .init(data: lap)
        countCell = .init(data: count)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hstack.addArrangedSubview(self.distanceCell!)
            self.hstack.addArrangedSubview(self.lapCell!)
            self.hstack.addArrangedSubview(self.countCell!)
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
