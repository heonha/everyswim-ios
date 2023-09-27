//
//  DatePickerCell.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit
import Combine

final class DatePickerDayCell: UICollectionViewCell {
    
    static let identifier = "DatePickerDayCell"
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: DatePickerViewModel!
    
    var isShadowHidden = true {
        didSet {
            circleContainer.isHidden = isShadowHidden
        }
    }
    
    var dateValue: DateValue! {
        didSet {
            daySetter(dateValue)
        }
    }
    
    lazy var textColor = viewModel
        .isSameDay(dateValue.date, viewModel.selectedDate)
    ? UIColor.black
    : UIColor.tintColor
    
    var circleInset: CGFloat = 8
    var dayViewInset: CGFloat = 10
    let circleColor = AppUIColor.primary
    
    private let baseView = UIView()
        .backgroundColor(.clear)
    
    lazy var dayView = ViewFactory
        .label(dateValue.day.description)
        .font(.custom(.sfProBold, size: 16))
        .foregroundColor(textColor)
        .textAlignemnt(.center)
    
    lazy var circleContainer = UIView()
        .backgroundColor(.white)
    
    lazy var circleShadowView = UIView()
        .backgroundColor(.white)
        .shadow(color: .black, x: 0, y: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        configure()
    }
    
    private func layout() {
        self.contentView.addSubview(baseView)
        baseView.addSubview(circleContainer)
        circleContainer.addSubview(circleShadowView)
        baseView.addSubview(dayView)

        baseView.snp.makeConstraints { make in
            make.size.equalTo(viewModel.getCellSize())
        }
       
        dayView.snp.makeConstraints { make in
            make.size.equalTo(baseView).inset(dayViewInset)
            make.center.equalTo(baseView)
        }
        
        circleContainer.snp.makeConstraints { make in
            make.size.equalTo(baseView)
            make.center.equalTo(baseView)
        }
        
        circleShadowView.snp.makeConstraints { make in
            make.edges.equalTo(circleContainer).inset(circleInset)
        }


    }
    
    private func configure() {
        dayView.layer.cornerRadius = viewModel.getDayViewRadius(rootViewSize: contentView.frame.size.width, inset: dayViewInset)
        dayView.clipsToBounds = true
        
        circleShadowView.layer.cornerRadius =  self.circleShadowView.frame.width / 2
    }

    private func daySetter(_ value: DateValue) {
        if value.day != -1 {
            self.dayView.text = value.day.description
            
            if viewModel.hasEvent(date: value.date) {
                updateCell(type: .hasEvent)
            } else {
                updateCell(type: .noEvent)
            }
        } else {
            updateCell(type: .empty)
        }
    }
    
    private func updateCell(type: DatePickerEventType) {
        switch type {
        case .hasEvent:
            self.dayView.textColor = AppUIColor.whithThickMaterialColor
            self.dayView.backgroundColor = AppUIColor.primary
            
        case .noEvent:
            self.dayView.textColor = UIColor(hex: "000000", alpha: 0.7)
            self.dayView.backgroundColor = .white
            
        case .empty:
            self.dayView.text = ""
            self.dayView.backgroundColor = .white
        }
    }
    
}

