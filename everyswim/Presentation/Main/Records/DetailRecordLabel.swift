//
//  DetailRecordLabel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit
import SnapKit

final class DetailRecordLabel: UIView {
    
    private var type: DetailCellLabelType
    
    private var textAlignment: NSTextAlignment
    private var stackAlignment: UIStackView.Alignment

    private lazy var dataLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProBold, size: 27))
        .foregroundColor(AppUIColor.label)
        .textAlignemnt(textAlignment)
    
    private lazy var unitLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(AppUIColor.label)
        .textAlignemnt(textAlignment)

    
    private lazy var typeLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProLight, size: 18))
        .foregroundColor(AppUIColor.secondaryLabel)
        .textAlignemnt(textAlignment)

    
    private lazy var dataHStack = ViewFactory.hStack()
        .addSubviews([dataLabel, unitLabel])
        .alignment(.bottom)
        .distribution(.fillProportionally)
    
    private lazy var vstack = ViewFactory.vStack()
        .addSubviews([dataHStack, typeLabel])
        .alignment(stackAlignment)
        .distribution(.fillProportionally)
    
    // MARK: - Initializer
    init(type: DetailCellLabelType, textAlignment: NSTextAlignment = .left, stackAlignment: UIStackView.Alignment = .leading) {
        self.type = type
        self.textAlignment = textAlignment
        self.stackAlignment = stackAlignment
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setType()
        layout()
    }
    
    // MARK: - 구현
    func setData(data: String) {
        self.dataLabel.text = data
    }
    
    private func setType() {
        dataLabel.adjustsFontSizeToFitWidth = true
        typeLabel.text = type.getTypeLabel()
        unitLabel.text = type.getUnit()
    }
    
    private func layout() {
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(122)
            make.height.greaterThanOrEqualTo(50)
        }
        
        self.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
}
