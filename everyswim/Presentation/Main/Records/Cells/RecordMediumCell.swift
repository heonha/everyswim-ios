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
        .addSubviews([profileStackView, recordStackView])
        .distribution(.fillProportionally)
        .spacing(10)
    
    // MARK: - Profile Stack
    private lazy var profileStackView = ViewFactory
        .hStack()
        .addSubviews([profileImageView, titleLabels])
        .alignment(.top)
        .spacing(10)
        
    private lazy var profileImageView: UIImageView =  {
        let profileImage = UIImage(systemName: "figure.pool.swim")
        
        let imageView = UIImageView()
            .contentMode(.scaleAspectFit)
            .setImage(profileImage)
            .cornerRadius(4) as! UIImageView

        return imageView
    }()
    

    // MARK: TitleLabels
    private lazy var titleLabels = ViewFactory
        .vStack()
        .alignment(.fill)
        .distribution(.fillProportionally)
        .addSubviews([dateLabel, durationTimeLabel, workoutTitleLabel])
    
    private lazy var dateLabel = ViewFactory
        .label("0000-00-00")
        .font(.custom(.sfProMedium, size: 15))
        .textAlignemnt(.right)
        .foregroundColor(.secondaryLabel)
        .adjustsFontSizeToFitWidth()

    private lazy var durationTimeLabel = ViewFactory
        .label("오전 00:00 ~ 오전 00:00")
        .font(.custom(.sfProLight, size: 14))
        .textAlignemnt(.right)
        .foregroundColor(.secondaryLabel)
        .adjustsFontSizeToFitWidth()

    private lazy var workoutTitleLabel = ViewFactory
        .label("")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(AppUIColor.label)

    // MARK: - Bottom Stack (Records)
    private lazy var recordStackView = ViewFactory
        .hStack()
        .addSubviews([leftLabel, 
                      UIView.divider(width: 0.5, height: 30),
                      centerLabel,
                      UIView.divider(width: 0.5, height: 30),
                      rightLabel])
        .distribution(.fillProportionally)
        .alignment(.center)
        .contentHuggingPriority(.init(rawValue: 251), for: .vertical)
        
    /// 거리
    private lazy var leftLabel = ViewFactory
        .label("--- m")
        .font(.custom(.sfProBold, size: 20))
        .textAlignemnt(.center)
    
    /// 칼로리
    private lazy var centerLabel = ViewFactory
        .label("-- kcal")
        .font(.custom(.sfProBold, size: 20))
        .textAlignemnt(.center)
        .contentHuggingPriority(.init(rawValue: 251), for: .horizontal) as! UILabel

    /// 시간
    private lazy var rightLabel = ViewFactory
        .label("-- 분")
        .font(.custom(.sfProBold, size: 20))
        .textAlignemnt(.center)
    
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
        contentView.layer.setFigmaShadow(color: .black, x: 0, y: 0, spread: 0)
        contentView.layer.cornerRadius = 12
        rightLabel.adjustsFontSizeToFitWidth = true

    }
    
    private func layout() {
        contentView.addSubview(mainVStack)

        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(4)
        }

        mainVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.verticalEdges.equalTo(contentView).inset(12)
            make.center.equalTo(contentView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        recordStackView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }

    }
    
    public func setData(_ data: SwimMainData) {
        self.data = data
    }
    
    public func getData() -> SwimMainData {
        return self.data
    }
    
    private func updateUI(from data: SwimMainData) {
        self.dateLabel.text = data.startDate.toString(.fullDotDate)
        
        let distance = data.distanceString
        leftLabel.text = distance
        leftLabel.setSecondaryAttributeText(separate: "m",
                                            font: .custom(.sfProBold, size: 14),
                                            color: AppUIColor.grayTint)
        
        centerLabel.text = data.totalKcalString
        centerLabel.setSecondaryAttributeText(separate: "kcal",
                                            font: .custom(.sfProBold, size: 14),
                                            color: AppUIColor.grayTint)
        
        let durationTime = data.durationTime

        durationTimeLabel.text = "\(durationTime)"

        let duration = data.durationString
        
        let attrDuration = NSMutableAttributedString(string: duration)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: AppUIColor.grayTint, .font: UIFont.custom(.sfProBold, size: 14)]
        attrDuration.addAttributes(attributes, range: (duration as NSString).range(of: "시간"))
        attrDuration.addAttributes(attributes, range: (duration as NSString).range(of: "분"))
        
        self.rightLabel.attributedText = attrDuration
    }
    
}

#if DEBUG
import SwiftUI

struct SwimRecordMediumCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            RecordMediumCell()
        }
        .frame(width: .infinity, height: 120)
    }
}
#endif

