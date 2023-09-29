//
//  ActivityViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit

final class ActivityViewController: UIViewController {
    
    // 셀렉터 (일간 - 주간 - 월간)
    private var dateSelecter = UISegmentedControl(items: ["일간", "주간", "월간"])
    
    // 이번주 - 지난주 ....
    private let weekSelecter = ViewFactory.label("이번 주")
        .font(.custom(.sfProBold, size: 17))
        .foregroundColor(.secondaryLabel)
    
    // 몇 미터
    private lazy var distanceLabel = ViewFactory
        .label("--")
        .font(.custom(.sfProBold, size: 80))
        .foregroundColor(.label)
    
    private lazy var distanceUnitLabel = ViewFactory
        .label("Meters")
        .font(.custom(.sfProMedium, size: 25))
        .foregroundColor(.secondaryLabel)
    
    private lazy var distanceStack = ViewFactory.hStack()
        .addSubviews([distanceLabel, distanceUnitLabel])
        .alignment(.bottom)
        .distribution(.fillProportionally)
        .spacing(8)
    
    // 수영 횟수
    private lazy var swimRecordLabel = RecordDetailCellLabel(type: .swim,
                                                             textAlignment: .center,
                                                             stackAlignment: .center)
    
    // 평균 페이스
    private lazy var averagePaceRecordLabel = RecordDetailCellLabel(type: .averagePaceWithoutUnit,
                                                                    textAlignment: .center,
                                                                    stackAlignment: .center)
    
    // 수영 시간
    private lazy var durationRecordLabel = RecordDetailCellLabel(type: .duration,
                                                                 textAlignment: .center,
                                                                 stackAlignment: .center)
    
    private lazy var recordHStack = ViewFactory.hStack()
        .addSubviews([swimRecordLabel, averagePaceRecordLabel, durationRecordLabel])
        .distribution(.fillEqually)
        .alignment(.center)
        .spacing(8)
    
    private lazy var recordMainStack = ViewFactory.vStack()
        .addSubviews([weekSelecter, distanceStack, recordHStack])
        .spacing(30)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    private lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([dateSelecter, recordMainStack, graphView])
        .spacing(30)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    // 주간 그래프
    private lazy var graphView = UIView()
    
    // 주간 활동
    private lazy var activitySectionView = UIView()
    
    // 주간활동 tableview
    private let activityTitle = ViewFactory.label("주간 활동")
        .font(.custom(.sfProLight, size: 18))
        .foregroundColor(.label)
    
    private lazy var activityTableview = BaseTableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func configure() {
        // 이번주 기록 가져오기
        averagePaceRecordLabel.setData(data: "3")
        averagePaceRecordLabel.setData(data: "-'--''")
        durationRecordLabel.setData(data: "1:23")
    }
    
    private func layout() {
        view.addSubview(mainVStack)
        mainVStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        dateSelecter.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(32)
        }
        
        recordHStack.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(30)
            make.height.equalTo(70)
        }
        
        graphView.backgroundColor = .systemGray2
        graphView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.width.equalTo(mainVStack).inset(18)
        }
        
        view.addSubview(activitySectionView)
        activitySectionView.addSubview(activityTitle)
        activitySectionView.addSubview(activityTableview)
        
        activitySectionView.backgroundColor = .systemGray4
        activitySectionView.snp.makeConstraints { make in
            make.top.equalTo(mainVStack.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
        
        activityTitle.snp.makeConstraints { make in
            make.top.equalTo(activitySectionView).inset(20)
            make.centerX.equalTo(activitySectionView)
        }
        activityTableview.backgroundColor = .systemBlue
        activityTableview.snp.makeConstraints { make in
            make.top.equalTo(activityTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(activitySectionView).inset(22)
            make.bottom.equalTo(activitySectionView)
        }
        
        
    }
    
    private func bind() {
        
    }
    
}

#if DEBUG
import SwiftUI

struct ActivityViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ActivityViewController()
        }
        .ignoresSafeArea()
    }
}
#endif

