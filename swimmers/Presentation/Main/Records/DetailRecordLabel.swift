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
        .foregroundColor(.label)
        .textAlignemnt(textAlignment)
    
    private lazy var unitLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProBold, size: 20))
        .foregroundColor(.label)
        .textAlignemnt(textAlignment)

    
    private lazy var typeLabel = ViewFactory
        .label("-")
        .font(.custom(.sfProLight, size: 18))
        .foregroundColor(.secondaryLabel)
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
    
    // MARK: - Label Type
    enum DetailCellLabelType {
        case averagePace
        case averagePaceWithoutUnit
        case duration
        case activeKcal
        case restKcal
        case averageBPM
        case poolLength
        case swim

        func getTypeLabel() -> String {
            switch self {
            case .averagePace, .averagePaceWithoutUnit:
                return "평균 페이스"
            case .duration:
                return "운동시간"
            case .activeKcal:
                return "활동 칼로리"
            case .restKcal:
                return "휴식 칼로리"
            case .averageBPM:
                return "평균 심박수"
            case .poolLength:
                return "레인 길이"
            case .swim:
                return "수영"
            }
        }
        
        func getUnit() -> String {
            switch self {
            case .averagePace:
                return "/100m"
            case .averagePaceWithoutUnit:
                return ""
            case .duration, .swim:
                return ""
            case .activeKcal, .restKcal:
                return "kcal"
            case .averageBPM:
                return "BPM"
            case .poolLength:
                return "m"
            }
        }
        
    }

    
}
