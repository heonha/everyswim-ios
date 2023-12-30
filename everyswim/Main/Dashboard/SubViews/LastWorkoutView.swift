//
//  LastWorkoutView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/30/23.
//

import UIKit
import SnapKit

/// [Dashboard] 마지막 운동 기록 Cell을 담은 View 입니다.
final class LastWorkoutView: BaseUIView {
    
    private lazy var vStackView = ViewFactory
        .vStack(subviews: [eventTitle, lastWorkoutCell])
        .distribution(.fill)
        .alignment(.center)
        .spacing(4)
    
    /// [최근 운동 기록] Views - `title`
    private let eventTitle = ViewFactory
        .label("최근 기록")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.gray)
        .textAlignemnt(.left)
    
    /// [최근 운동 기록] `Cell`
    lazy var lastWorkoutCell = RecordSmallCell(data: nil,
                                               showDate: true)
    
    init() {
        super.init()
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    func updateData(_ data: SwimMainData) {
        lastWorkoutCell.updateData(data)
    }
    
    private func layout() {
        self.addSubview(vStackView)
        
        vStackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(20)
        }
        
        eventTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
        }
        
        lastWorkoutCell.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
        }
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct LastWorkoutView_Previews: PreviewProvider {
    
    static let view = LastWorkoutView()
    static let data = SwimMainData.examples.first!
    
    static var previews: some View {
        UIViewPreview {
            view
        }
        .frame(height: 100)
        .frame(width: 393)
        .onAppear {
            view.updateData(data)
        }
    }
}
#endif
