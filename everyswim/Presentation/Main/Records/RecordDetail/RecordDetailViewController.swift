//
//  RecordDetailViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit
import SnapKit

final class RecordDetailViewController: UIViewController {
    
    private let contentView = UIView()
    private var data: SwimMainData
    
    // 날짜 라벨
    private lazy var dateLabel = ViewFactory
        .label("----. --. --")
        .font(.custom(.sfProLight, size: 17))
        .foregroundColor(.tertiaryLabel)
    
    // 시간 라벨
    private lazy var timeLabel = ViewFactory
        .label("오전 00:00 - 00:00")
        .font(.custom(.sfProMedium, size: 17))
        .foregroundColor(.secondaryLabel)

    // 수영장 라벨
    private lazy var poolLabel = ViewFactory
        .label("수영장")
        .font(.custom(.sfProLight, size: 14))
        .foregroundColor(.secondaryLabel)

    // 거리 라벨 + 타이틀
    private lazy var distanceLabel = ViewFactory
        .label("--")
        .font(.custom(.sfProBold, size: 80))
        .foregroundColor(.label)
    
    private lazy var distanceUnitLabel = ViewFactory
        .label("meter")
        .font(.custom(.sfProMedium, size: 25))
        .foregroundColor(.secondaryLabel)
    
    private lazy var distanceStack = ViewFactory.hStack()
        .addSubviews([distanceLabel, distanceUnitLabel])
        .alignment(.bottom)
        .distribution(.fillProportionally)
    
    // 평균 페이스 라벨 + 타이틀
    private lazy var averagePaceLabel = DetailRecordLabel(type: .averagePace)

    // 운동시간 라벨 + 타이틀
    private lazy var durationLabel = DetailRecordLabel(type: .duration)

    // 활동 칼로리 라벨
    private lazy var activeKcalLabel = DetailRecordLabel(type: .activeKcal)
    
    // 휴식칼로리 라벨
    private lazy var restKcalLabel = DetailRecordLabel(type: .restKcal)
    
    // 평균 심박수 라벨
    private lazy var averageBPMLabel = DetailRecordLabel(type: .averageBPM)
    
    // 수영장 길이 라벨
    private lazy var poolLength = DetailRecordLabel(type: .poolLength)
    
    private lazy var leftDataVStack = ViewFactory.vStack()
        .addSubviews([averagePaceLabel, activeKcalLabel, averageBPMLabel])
        .distribution(.fillEqually)
    
    private lazy var rightDataVStack = ViewFactory.vStack()
        .addSubviews([durationLabel, restKcalLabel, poolLength])
        .distribution(.fillEqually)
    
    private lazy var dataHStack = ViewFactory.hStack()
        .addSubviews([leftDataVStack, rightDataVStack])
        .distribution(.fillProportionally)
        .spacing(36)
    
    // MARK: - Init & LifeCycles
    init(data: SwimMainData) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar(true)
    }
    
    // MARK: - 구현
    private func configure() {
        self.navigationItem.title = "-"
        self.view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        self.view.addSubview(contentView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(poolLabel)
        contentView.addSubview(distanceStack)
        contentView.addSubview(dataHStack)

        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view).inset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(14)
            make.horizontalEdges.equalTo(contentView).inset(8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(8)
        }
        
        poolLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(14)
            make.trailing.equalTo(contentView)
            make.width.greaterThanOrEqualTo(100)
        }
        
        distanceStack.snp.makeConstraints { make in
            make.top.equalTo(poolLabel.snp.bottom).offset(40)
            make.centerX.equalTo(contentView)
            make.height.greaterThanOrEqualTo(100)
        }
        
        dataHStack.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(40)
            make.centerX.equalTo(contentView)
            make.height.greaterThanOrEqualTo(213)
        }
        
    }
    
    private func updateUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let weekday = self.data.startDate.toString(.weekdayTime)
            
            self.navigationItem.title = "\(weekday) 수영"


            self.dateLabel.text = self.data.startDate.toString(.fullDotDate)
            self.timeLabel.text = self.data.durationTime
            self.poolLabel.text = "알수없는 수영장"
            self.distanceLabel.text = self.data.unwrappedDistance.toString()
            
            self.averagePaceLabel.setData(data: "-:--")
            self.durationLabel.setData(data: self.data.duration.toRelativeTime(.hourMinute, unitStyle: .full))
            self.activeKcalLabel.setData(data: self.data.detail?.activeKcal?.toString() ?? "-")
            self.restKcalLabel.setData(data: self.data.detail?.restKcal?.toString() ?? "-")
            self.averageBPMLabel.setData(data: "---")
            self.poolLength.setData(data: "--")
        }
    }
    
}
