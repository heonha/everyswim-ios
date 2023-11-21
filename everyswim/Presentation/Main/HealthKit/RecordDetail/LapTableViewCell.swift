//
//  LapTableViewCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/5/23.
//

import UIKit
import SnapKit

class LapTableViewCell: UITableViewCell, ReuseableObject {
    
    static var reuseId: String = "LapTableViewCell"
    
    var data: SwimMainData?
    
    private let lapNoLabel = ViewFactory
        .label("1")
        .textAlignemnt(.center)
        .font(.custom(.sfProLight, size: 18))
    
    private let strokeStyleLabel = ViewFactory
        .label("자유형")
        .textAlignemnt(.center)
        .font(.custom(.sfProLight, size: 18))

    private let paceLabel = ViewFactory
        .label("1'00''")
        .font(.custom(.sfProLight, size: 16))
        .contentHuggingPriority(.init(rawValue: 249), for: .horizontal) as! UILabel

    private let poolDistanceLabel = ViewFactory
        .label("25m")
        .textAlignemnt(.center)
        .font(.custom(.sfProLight, size: 15))

    private lazy var mainHStack = ViewFactory
        .hStack()
        .addSubviews([lapNoLabel, strokeStyleLabel, paceLabel, poolDistanceLabel])
        .spacing(16)
        .distribution(.fillProportionally)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    
    func layout() {
        contentView.addSubview(mainHStack)
        mainHStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(12)

            make.height.equalTo(60)
        }
        
        lapNoLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }

        
        strokeStyleLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }

        
        poolDistanceLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
    }
    
    func setData(lapData: Lap) {
        self.lapNoLabel.text = lapData.index.description
        self.strokeStyleLabel.text = lapData.style?.name
        self.paceLabel.text = lapData.dateInterval.duration.toRelativeTime(.hourMinuteSeconds, unitStyle: .short)
    }
    
    func setLegend() {
        self.lapNoLabel.text = "랩"
        self.strokeStyleLabel.text = "영법"
        self.paceLabel.text = "페이스"
        self.poolDistanceLabel.text = "거리"
        
        [lapNoLabel, strokeStyleLabel, paceLabel, poolDistanceLabel]
            .forEach { label in
                label.textColor = .secondaryLabel
                label.font = .custom(.sfProBold, size: 18)
            }
        
    }

}
