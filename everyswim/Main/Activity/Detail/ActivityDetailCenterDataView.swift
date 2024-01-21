//
//  ActivityDetailCenterDataView.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit

final class ActivityDetailCenterDataView: UIView {
    
    // 수영 횟수
    private lazy var swimRecordLabel = ActivityDetailCenterLabel(type: .swim,
                                                         textAlignment: .center,
                                                         stackAlignment: .center)
    
    // 평균 페이스
    private lazy var averagePaceRecordLabel = ActivityDetailCenterLabel(type: .averagePaceWithoutUnit,
                                                                textAlignment: .center,
                                                                stackAlignment: .center)
    
    // 수영 시간
    private lazy var durationRecordLabel = ActivityDetailCenterLabel(type: .duration,
                                                             textAlignment: .center,
                                                             stackAlignment: .center)
    
    private lazy var recordHStack = ViewFactory.hStack()
        .addSubviews([swimRecordLabel, averagePaceRecordLabel, durationRecordLabel])
        .distribution(.fillEqually)
        .alignment(.center)
        .spacing(8)
    
    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        self.addSubview(recordHStack)
        recordHStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setData(_ data: SwimSummaryViewModel?) {
        guard let data = data else {return}
        self.swimRecordLabel.setData(data: data.count.description)
        self.averagePaceRecordLabel.setData(data: data.averagePace)
        self.durationRecordLabel.setData(data: data.time)
    }
    
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct ActivityDetailCenterDataView_Previews: PreviewProvider {
    
    static let view = ActivityDetailCenterDataView()
    static let data = SwimSummaryViewModel.examples.first
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(height: 100)
        .onAppear {
            self.view.setData(data)
        }
    }
}
#endif
