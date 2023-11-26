//
//  RecordSmallCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit

final class RecordSmallCell: UITableViewCell {
    
    static let reuseId = "RecordSmallCell"
    
    var data: SwimMainData! {
        didSet {
            if let data = data {
                self.dayLabel.text = data.getDayDotMonth()
                self.weekdayLabel.text = data.getWeekDay()
                self.title.text = "\(data.getWeekDay()) 수영"
                self.record.text = "\(records.duration) | \(records.distance)m | \(records.lap) Lap"
                
                if self.showRelativedate {
                    let label = self.rightLabel as! UILabel
                    label.text = Date.relativeDate(from: data.startDate)
                }
            }
        }
    }
    
    private var showRelativedate: Bool = false
    
    private lazy var mainView: UIStackView = {
        return ViewFactory.hStack(subviews: [dayView, divider, bodyView, rightLabel],
                                  spacing: 16,
                                  alignment: .center,
                                  distribution: .fill)
        .setEdgeInset(.init(top: 8, leading: 24, bottom: 8, trailing: 24))
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
    
    private lazy var dayLabel = ViewFactory
        .label("")
        .font(.custom(.sfProMedium, size: 16))
        .foregroundColor(AppUIColor.primaryBlue)
    
    private lazy var weekdayLabel = ViewFactory
        .label("")
        .font(.custom(.sfProLight, size: 12))
        .foregroundColor(AppUIColor.primaryBlue)
    
    // MARK: 수영 기록
    private lazy var records = data.getSimpleRecords()
    
    private lazy var title = ViewFactory
        .label("")
        .font(.custom(.sfProMedium, size: 15))
        .foregroundColor(UIColor.black)
    
    private lazy var record = ViewFactory
        .label("")
        .font(.custom(.sfProLight, size: 13))
        .foregroundColor(AppUIColor.primaryBlue)
    
    private lazy var bodyView: UIStackView = ViewFactory.vStack()
        .addSubviews([title, record, UIView.spacer()])
        .alignment(.fill)
        .distribution(.fill)
        .contentHuggingPriority(.init(rawValue: 249), for: .horizontal)
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .secondarySystemFill
        return divider
    }()
    
    
    // MARK: 우측 이미지
    private lazy var rightLabel: UIView = {
        if self.showRelativedate {
            let relativeDateLabel = ViewFactory
                .label(Date.relativeDate(from: data.startDate))
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
    
    // MARK: - Initialize & LifeCycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    init(data: SwimMainData, showDate: Bool = false, style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        self.data = data
        self.showRelativedate = showDate
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
}

extension RecordSmallCell {
    
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
    
    func getData() -> SwimMainData {
        return self.data
    }
    
    private func configure() {
        self.selectedBackgroundView = UIView()
    }
    
    private func setLayout() {
        mainView.layer.cornerRadius = 12
        mainView.layer.setFigmaShadow(alpha: 0.22, x: 0, y: 0, blur: 2, spread: 0, radius: 12)
        mainView.backgroundColor = UIColor.white

        bodyView.addArrangedSubview(title)
        bodyView.addArrangedSubview(record)

        self.addSubview(mainView)
        
        if showRelativedate {
            mainView.snp.makeConstraints { make in
                make.center.equalTo(self)
                make.horizontalEdges.equalTo(self)
            }
        } else {
            mainView.snp.makeConstraints { make in
                make.center.equalTo(self)
                make.horizontalEdges.equalTo(self).inset(16)
            }
        }

        divider.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(self.snp.height).inset(16)
        }
        
        dayView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(50)
        }
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct EventListUICell_Previews: PreviewProvider {
    
    static let view = RecordSmallCell()
    static let data = TestObjects.swimmingData.first!
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(height: 80)
        .frame(width: .infinity)
        .onAppear {
            view.updateData(data)
        }
    }
}
#endif

