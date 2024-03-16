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
    
    lazy var textColor = UIColor.label
    
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
        .backgroundColor(.clear)
    
    lazy var circleShadowView = UIView()
        .backgroundColor(AppUIColor.whiteUltraThinMaterialColor)
        .shadow(color: .black, alpha: 0.4, x: 0, y: 0, blur: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
        layout()
    }
    
    private func layout() {
        self.contentView.addSubview(baseView)
        baseView.addSubview(circleContainer)
        circleContainer.addSubview(circleShadowView)
        baseView.addSubview(dayView)

        baseView.snp.makeConstraints { make in
            make.size.equalTo(viewModel.getSizeForDayCell())
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
        dayView.layer.cornerRadius = viewModel.getCornerRadiusForDayCell(rootViewSize: contentView.frame.size.width, inset: dayViewInset)
        
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
            self.dayView.textColor = UIColor.label
            self.dayView.backgroundColor = .clear
            self.dayView.layer.borderWidth = 2
            self.dayView.layer.borderColor = UIColor.init(hex: "1288EC").cgColor
            
        case .noEvent:
            self.dayView.textColor = UIColor.label
            self.dayView.backgroundColor = .clear
            self.dayView.layer.borderWidth = 0
            self.dayView.layer.borderColor = .none
            
        case .empty:
            self.dayView.text = ""
            self.dayView.backgroundColor = .clear
            self.dayView.layer.borderWidth = 0
            self.dayView.layer.borderColor = .none

        }
    }
    
    func applyGradientBorder(to view: UIView, colors: [CGColor], width: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: view.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        view.layer.addSublayer(gradientLayer)
    }
}

#if DEBUG
import SwiftUI

struct DatePickerDayCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DatePickerController(viewModel: DatePickerViewModel())
        }
        .ignoresSafeArea()
    }
}
#endif
