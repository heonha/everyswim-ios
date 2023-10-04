//
//  RecordMediumCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit
import SnapKit

final class RecordMediumCell: UITableViewCell, ReuseableCell {
    
    static var reuseId: String = "SwimRecordMediumCell"
    
    private lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([profileStackView, workoutTitleLabel, recordStackView])
        .spacing(15)
    
    // MARK: - Profile Stack
    private lazy var profileStackView = ViewFactory
        .hStack()
        .addSubviews([profileImage, profileUserNameSubStack])
    
    private var profileImage: UIImageView = UIImageView()
        .contentMode(.scaleAspectFill)
        .setImage(UIImage(named: "Avatar"))
    
    private lazy var profileUserNameSubStack = ViewFactory
        .vStack()
        .addSubviews([userNameLabel, dateLabel])
    
    private lazy var userNameLabel = ViewFactory
        .label("User Name")
        .font(.custom(.sfProBold, size: 14))
        .contentHuggingPriority(.init(251), for: .vertical)
    
    private lazy var dateLabel = ViewFactory
        .label("")
        .font(.custom(.sfProLight, size: 11))
        .foregroundColor(AppUIColor.grayTint)
    
    
    // MARK: - Middle Stack
    private lazy var workoutTitleLabel = ViewFactory
        .label("월요일 오전 수영")
        .font(.custom(.sfProMedium, size: 16))
    
    // MARK: - Bottom Stack (Records)
    private lazy var recordStackView = ViewFactory
        .hStack()
        .addSubviews([leftLabel, 
                      UIView.divider(width: 1, height: 30),
                      centerLabel,
                      UIView.divider(width: 1, height: 30),
                      rightLabel])
        .distribution(.fillProportionally)
        .alignment(.center)
        .contentHuggingPriority(.init(rawValue: 251), for: .vertical)
        
    /// 거리
    private lazy var leftLabel = ViewFactory
        .label("--- m")
        .font(.custom(.sfProBold, size: 24))
        .textAlignemnt(.center)
    
    /// 칼로리
    private lazy var centerLabel = ViewFactory
        .label("-- kcal")
        .font(.custom(.sfProBold, size: 24))
        .textAlignemnt(.center)
        .contentHuggingPriority(.init(rawValue: 251), for: .horizontal) as! UILabel

    /// 시간
    private lazy var rightLabel = ViewFactory
        .label("-- 분")
        .font(.custom(.sfProBold, size: 20))
        .textAlignemnt(.center)

    private lazy var rightArrowImage = UIImageView()
        .setSymbolImage(systemName: "chevron.right", color: AppUIColor.grayTint)
        .contentMode(.scaleAspectFit)
    
    
    // MARK: - Init
    private var data: SwimMainData! {
        didSet {
            self.updateUI(from: data)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        layout()
    }
    
    override func layoutSubviews() {
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configure() {
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.setFigmaShadow(color: .black)
        contentView.layer.cornerRadius = 12
    }
    
    private func layout() {
        contentView.addSubview(mainVStack)
        contentView.addSubview(rightArrowImage)

        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(6)
        }
        
        mainVStack.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(18)
            make.center.equalTo(contentView)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        rightArrowImage.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(14)
            make.centerY.equalTo(contentView)
            make.size.equalTo(18)
        }
        
    }
    
    public func setData(_ data: SwimMainData) {
        self.data = data
    }
    
    public func getData() -> SwimMainData {
        return self.data
    }
    
    private func updateUI(from data: SwimMainData) {
        self.dateLabel.text = data.date
        
        let distance = data.distanceString
        leftLabel.text = distance
        leftLabel.setSecondaryAttributeText(separate: "m",
                                            font: .custom(.sfProBold, size: 16),
                                            color: AppUIColor.grayTint)
        
        centerLabel.text = data.totalKcalString
        centerLabel.setSecondaryAttributeText(separate: "kcal",
                                            font: .custom(.sfProBold, size: 16),
                                            color: AppUIColor.grayTint)
        
        let weekday = data.startDate.toString(.weekdayTime)
        
        workoutTitleLabel.text = "\(weekday) 수영"
        
        self.rightLabel.text = data.durationString
    }
    
}

#if DEBUG
import SwiftUI

struct SwimRecordMediumCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ActivityViewController()
        }
        .frame(width: .infinity, height: 171)
    }
}
#endif

