//
//  EventListUICell.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit

final class EventListUICell: UIView {
    
    private let data: SwimMainData
    private var showRelativedate: Bool
    
    private lazy var mainView = makeMainHstackView()
    private lazy var dayView = makeDayView()
    private lazy var divider = makeDivider()
    private lazy var bodyView = bodyStackView()
    private lazy var rightLabel = rightLabelView()
    
    init(data: SwimMainData, showDate: Bool = false) {
        self.data = data
        self.showRelativedate = showDate
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EventListUICell {
    
    private func setLayout() {
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor(hex: "000000").cgColor
        self.layer.shadowOpacity = 0.12
        self.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        self.backgroundColor = .systemBackground
        
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        self.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        divider.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(self.snp.height).inset(16)
        }
        
        dayView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(40)
        }
        
    }
  
    private func makeMainHstackView() -> UIStackView {
        let hstack = ViewFactory.hStack(subviews: [dayView, divider, bodyView, rightLabel], spacing: 16, alignment: .center, distribution: .equalSpacing)
            .setEdgeInset(.init(top: 2, leading: 24, bottom: 2, trailing: 24))
        
        return hstack
    }
    
    private func makeDayView() -> UIStackView {
        let dayLabel = ViewFactory.label(data.getDayDotMonth())
            .font(.custom(.sfProMedium, size: 16))
            .foregroundColor(AppUIColor.primaryBlue)
        
        let weekdayLabel = ViewFactory.label(data.getWeekDay())
            .font(.custom(.sfProLight, size: 12))
            .foregroundColor(AppUIColor.primaryBlue)

        let vstack = ViewFactory
            .vStack(subviews: [dayLabel, weekdayLabel], spacing: 4, alignment: .center)
        vstack.setContentHuggingPriority(.init(251), for: .horizontal)
        vstack.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        return vstack
    }
    
    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .secondarySystemFill
        return divider

    }
    
    private func bodyStackView() -> UIStackView {
        let records = data.getSimpleRecords()
        
        let title = ViewFactory.label("\(data.getWeekDay()) 수영")
            .font(.custom(.sfProMedium, size: 15))
            .foregroundColor(UIColor.black)
        
        let record = ViewFactory
            .label("\(records.duration) | \(records.distance)m | \(records.lap) Lap")
            .font(.custom(.sfProLight, size: 13))
            .foregroundColor(AppUIColor.primaryBlue)
        
        let vstack = ViewFactory.vStack(subviews: [title, record], alignment: .leading)
        vstack.setContentHuggingPriority(.init(249), for: .horizontal)
        
        return vstack
    }
    
    private func rightLabelView() -> UIView {
        if showRelativedate {
            let relativeDateLabel = ViewFactory.label(Date.relativeDate(from: data.startDate))
                .font(.custom(.sfProLight, size: 12))
                .foregroundColor(AppUIColor.grayTint)
            return relativeDateLabel
        } else {
            let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
            image.withTintColor(AppUIColor.grayTint)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.setContentHuggingPriority(.init(251), for: .horizontal)
            imageView.frame.size = .init(width: 24, height: 24)
            imageView.backgroundColor = UIColor.randomColor()
            return imageView
        }
    }
    
}

#if DEBUG
import SwiftUI

struct EventListUICell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview(view: EventListUICell(data: TestObjects.swimmingData.first!))
    }
}
#endif
