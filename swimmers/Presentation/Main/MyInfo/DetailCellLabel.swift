//
//  DetailCellLabel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit
import SnapKit

final class DetailCellLabel: UIView {
    
    private var type: DetailCellLabelType
    
    private lazy var dataLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProBold, size: 27))
        .foregroundColor(.label)
    
    private lazy var unitLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(.label)
    
    private lazy var typeLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProLight, size: 18))
        .foregroundColor(.secondaryLabel)
    
    private lazy var dataHStack = ViewFactory.hStack()
        .addSubviews([dataLabel, unitLabel])
        .alignment(.bottom)
        .distribution(.fillProportionally)
    
    private lazy var vstack = ViewFactory.vStack()
        .addSubviews([dataHStack, typeLabel])
        .alignment(.leading)
        .distribution(.fillProportionally)
    
    init(type: DetailCellLabelType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setType()
        layout()
    }
    
    func setData(data: String) {
        self.dataLabel.text = data
    }
    
    private func setType() {
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
