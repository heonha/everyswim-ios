//
//  LapTableViewCell.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/5/23.
//

import UIKit
import SnapKit

final class LapTableViewCell: UITableViewCell, ReuseableCell {
    
    static var reuseId: String = "LapTableViewCell"
    let cellHeight: CGFloat = 60.0
    
    private var data: SwimMainData?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setLegend()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        .adjustsFontSizeToFitWidth(true)
        .contentHuggingPriority(.init(rawValue: 249), for: .horizontal) as! UILabel

    private let durationLabel = ViewFactory
        .label("") // 00:00 ~ 00:00
        .font(.custom(.sfProLight, size: 16))
        .adjustsFontSizeToFitWidth(true)
        .contentHuggingPriority(.init(rawValue: 249), for: .horizontal) as! UILabel

    private lazy var durationVStack = ViewFactory.vStack()
        .spacing(2)
        .distribution(.fillEqually)
        .addSubviews([paceLabel])
    
    private let poolDistanceLabel = ViewFactory
        .label("- m")
        .textAlignemnt(.center)
        .font(.custom(.sfProLight, size: 15))

    private lazy var mainHStack = ViewFactory
        .hStack()
        .addSubviews([lapNoLabel, strokeStyleLabel, durationVStack, poolDistanceLabel])
        .spacing(16)
        .distribution(.fillProportionally)

    func layout() {
        contentView.addSubview(mainHStack)
        mainHStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(12)

            make.height.equalTo(self.cellHeight)
        }
        
        paceLabel.snp.makeConstraints { make in
            make.height.equalTo(mainHStack)
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
    
    func setData(lapData: LapSegment) {
        self.lapNoLabel.text = lapData.index.description
        self.strokeStyleLabel.text = lapData.laps.first?.style?.name
        
        self.paceLabel.text = lapData.pace()
        
        self.poolDistanceLabel.text = "\(lapData.poolLength) m"
        
        if self.strokeStyleLabel.text == nil {
            self.strokeStyleLabel.text = lapData.eventType?.name
            strokeStyleLabel.textColor = .systemBlue
            strokeStyleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    func setLegend() {
        self.lapNoLabel.text = "랩"
        self.strokeStyleLabel.text = "영법"
        self.paceLabel.text = "평균 페이스 (25m)"
        self.poolDistanceLabel.text = "거리"
        
        [lapNoLabel, strokeStyleLabel, paceLabel, poolDistanceLabel]
            .forEach { label in
                label.textColor = .secondaryLabel
                label.font = .custom(.sfProBold, size: 18)
            }
        
    }

}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct LapTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            LapTableViewCell()
        }
        .frame(height: 60)
    }
}
#endif
