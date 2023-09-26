//
//  SwimRecordSmallCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit

final class SwimRecordSmallCell: UITableViewCell {
    
    static let reuseId = "SwimRecordSmallCell"
    
    var data: SwimMainData! {
        didSet {
            if let data = data {
                self.dayLabel.text = data.getDayDotMonth()
                self.weekdayLabel.text = data.getWeekDay()
                self.title.text = "\(data.getWeekDay()) 수영"
                self.record.text = "\(records.duration) | \(records.distance)m | \(records.lap) Lap"
            }
        }
    }
    
    private var showRelativedate: Bool = false
    
    private lazy var mainView: UIStackView = {
        return ViewFactory.hStack(subviews: [dayView, divider, bodyView, rightLabel],
                                  spacing: 16,
                                  alignment: .center,
                                  distribution: .fill)
        .setEdgeInset(.init(top: 2, leading: 24, bottom: 2, trailing: 24))
    }()
    
    
    // MARK: DayView (Left)
    private lazy var dayView: UIStackView = {
        let vstack = ViewFactory
            .vStack(subviews: [dayLabel, weekdayLabel])
            .spacing(4)
            .alignment(.center)
        
        vstack.setContentHuggingPriority(.init(251), for: .horizontal)
        vstack.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        return vstack
    }()
    
    private lazy var dayLabel = ViewFactory.label("")
        .font(.custom(.sfProMedium, size: 16))
        .foregroundColor(AppUIColor.primaryBlue)
    
    private lazy var weekdayLabel = ViewFactory.label("")
        .font(.custom(.sfProLight, size: 12))
        .foregroundColor(AppUIColor.primaryBlue)
    
    // MARK: 수영 기록
    private lazy var records = data.getSimpleRecords()
    
    private lazy var title = ViewFactory.label("")
        .font(.custom(.sfProMedium, size: 15))
        .foregroundColor(UIColor.black)
    
    private lazy var record = ViewFactory
        .label("")
        .font(.custom(.sfProLight, size: 13))
        .foregroundColor(AppUIColor.primaryBlue)
    
    private lazy var bodyView: UIStackView = {
        let vstack = ViewFactory.vStack(subviews: [title, record, UIView.spacer()], alignment: .fill, distribution: .fill)
        vstack.setContentHuggingPriority(.init(249), for: .horizontal)
        return vstack
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .secondarySystemFill
        return divider
    }()
    
    
    // MARK: 우측 이미지
    private lazy var rightLabel: UIView = {
        if self.showRelativedate {
            let relativeDateLabel = ViewFactory.label(Date.relativeDate(from: data.startDate))
                .font(.custom(.sfProLight, size: 12))
                .foregroundColor(AppUIColor.grayTint)
            relativeDateLabel.setContentHuggingPriority(.init(251), for: .horizontal)

            return relativeDateLabel
        } else {
            let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
            image.withTintColor(AppUIColor.grayTint)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.setContentHuggingPriority(.init(251), for: .horizontal)
            imageView.frame.size = .init(width: 24, height: 24)
            imageView.tintColor = AppUIColor.grayTint
            return imageView
        }
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    init(data: SwimMainData, showDate: Bool = false, style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        self.data = data
        self.showRelativedate = showDate
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
}

extension SwimRecordSmallCell {
    
    func updateTitle(data: SwimMainData) {
        self.title.text = "\(data.getWeekDay()) 수영"
    }
    
    func updateRecord(data: SwimMainData) {
        let record = data.getSimpleRecords()
        self.title.text = "\(record.duration) | \(record.distance)m | \(record.lap) Lap"
    }

    func updateData(_ data: SwimMainData) {
        self.data = data
    }
    
    private func setLayout() {
        mainView.layer.cornerRadius = 12
        mainView.layer.shadowColor = UIColor(hex: "000000").cgColor
        mainView.layer.shadowOpacity = 0.12
        mainView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        mainView.backgroundColor = UIColor.white
        
        bodyView.addArrangedSubview(title)
        bodyView.addArrangedSubview(record)

        self.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(10)
            make.verticalEdges.equalTo(self).inset(6)
            make.center.equalTo(self)
        }
        
        divider.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(self.snp.height).inset(16)
        }
        
        dayView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(40)
        }
        
    }
    
}

#if DEBUG
import SwiftUI

struct EventListUICell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            SwimRecordSmallCell(data: TestObjects.swimmingData.first!)
        }
    }
}
#endif
