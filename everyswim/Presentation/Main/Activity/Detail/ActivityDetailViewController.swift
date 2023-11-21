//
//  ActivityDetailViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/28/23.
//

import UIKit
import SnapKit

final class ActivityDetailViewController: UIViewController {
    
    private let scrollView = BaseScrollView()
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
        .label("")
        .font(.custom(.sfProLight, size: 14))
        .textAlignemnt(.right)
        .foregroundColor(.secondaryLabel)
    
    private lazy var paceTitleLabel = ViewFactory
        .label("페이스")
        .font(.custom(.sfProLight, size: 24))
        .foregroundColor(AppUIColor.label)
    
    private lazy var distanceStack = DistanceBigLabel()
    
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
    
    private lazy var leftDataVStack = ViewFactory
        .vStack()
        .addSubviews([averagePaceLabel, activeKcalLabel, averageBPMLabel])
        .distribution(.fillEqually)
    
    private lazy var rightDataVStack = ViewFactory
        .vStack()
        .addSubviews([durationLabel, restKcalLabel, poolLength])
        .distribution(.fillEqually)
    
    private lazy var dataHStack = ViewFactory
        .hStack()
        .addSubviews([leftDataVStack, rightDataVStack])
        .distribution(.fillProportionally)
        .spacing(36)
    
    private lazy var lapTableView: UITableView = UITableView()
        .isScrollEnabled(true)
        .separatorColor(.secondarySystemFill)
        .isUserInteractionEnabled(false)
        .backgroundColor(.systemBackground)

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
        updateTableViewSize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar(true)
    }
    
    // MARK: - 구현
    private func configure() {
        self.navigationItem.title = "-"
        self.view.backgroundColor = .systemBackground
        
        self.lapTableView.delegate = self
        self.lapTableView.dataSource = self
        self.lapTableView.register(LapSplitCell.self, forCellReuseIdentifier: LapSplitCell.reuseId)
    }
 
    // MARK: Layout
    private func layout() {
 
        layoutScrollView()
        
        let contentView = scrollView.contentView
        let horizontalInset: CGFloat = 16
        let topOffset: CGFloat = 40

        layoutHeaderLabels(contentView: contentView, 
                           horizontalInset: horizontalInset)
        
        layoutDistanceStackView(contentView: contentView, 
                                topOffset: topOffset,
                                height: 100)
        
        layoutCenterDataStack(contentView: contentView, 
                              topOffset: topOffset,
                              height: 213)
        
        layoutPaceTitleLabel(contentView: contentView, 
                             topOffset: topOffset,
                             horizontalInset: horizontalInset,
                             height: 30)
        
        layoutLapTableView(contentView: contentView, 
                           topOffset: 10)
        
    }
    
    private func layoutScrollView() {
        self.view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

    }
    
    private func layoutLapTableView(contentView: UIView, 
                                    topOffset: CGFloat) {
        contentView.addSubview(lapTableView)
        
        lapTableView.snp.makeConstraints { make in
            make.top.equalTo(paceTitleLabel.snp.bottom).offset(topOffset)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    private func layoutPaceTitleLabel(contentView: UIView, 
                                      topOffset: CGFloat,
                                      horizontalInset: CGFloat,
                                      height: CGFloat) {
        
        contentView.addSubview(paceTitleLabel)
        
        paceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dataHStack.snp.bottom).offset(topOffset)
            make.horizontalEdges.equalTo(contentView).inset(horizontalInset)
            make.height.equalTo(height)
        }
    }
    
    private func layoutHeaderLabels(contentView: UIView, 
                                    horizontalInset: CGFloat) {
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(poolLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(14)
            make.horizontalEdges.equalTo(contentView).inset(horizontalInset)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(horizontalInset)
        }
        
        poolLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(14)
            make.trailing.equalTo(contentView).inset(horizontalInset)
            make.width.greaterThanOrEqualTo(100)
        }
    }
    
    private func layoutDistanceStackView(contentView: UIView, 
                                         topOffset: CGFloat,
                                         height: CGFloat) {
        contentView.addSubview(distanceStack)

        distanceStack.snp.makeConstraints { make in
            make.top.equalTo(poolLabel.snp.bottom).offset(topOffset)
            make.centerX.equalTo(contentView)
            make.height.greaterThanOrEqualTo(100)
        }
        
    }
    
    private func layoutCenterDataStack(contentView: UIView, 
                                       topOffset: CGFloat,
                                       height: CGFloat) {
        contentView.addSubview(dataHStack)

        dataHStack.snp.makeConstraints { make in
            make.top.equalTo(distanceStack.snp.bottom).offset(topOffset)
            make.centerX.equalTo(contentView)
            make.height.greaterThanOrEqualTo(height)
        }
    }
    
    
    // MARK: - UPDATE UI
    
    /// 데이터 받아서 UI 업데이트
    private func updateUI() {
        let weekday = self.data.startDate.toString(.weekdayTime)
        
        self.navigationItem.title = "\(weekday) 수영"
        
        // 날짜, 시간, 수영장
        self.dateLabel.text = self.data.startDate.toString(.fullDotDate)
        self.timeLabel.text = self.data.durationTime
        self.poolLabel.text = "OOO 수영장"
        
        // 거리
        self.distanceStack.setData(self.data.unwrappedDistance.toRoundupString(), unit: "m")
        
        // 평균페이스, 운동시간
        self.averagePaceLabel.setData(data: "-:--")
        self.durationLabel.setData(data: self.data.duration.toRelativeTime(.hourMinute, unitStyle: .full))
        
        // 심박수, 레인길이
        self.averageBPMLabel.setData(data: "---")
        self.poolLength.setData(data: "--")
        
        // 칼로리
        self.activeKcalLabel.setData(data: self.data.detail?.activeKcal?.toRoundupString() ?? "-")
        self.restKcalLabel.setData(data: self.data.detail?.restKcal?.toRoundupString() ?? "-")

    }
    
    /// Cell 갯수에 따라서 TableView 크기를 업데이트
    /// (Scrollview In Scrollview이기 때문에 tableView의 ContentSize를 유동적으로 변화하게함)
    func updateTableViewSize() {
        let count = data.laps.count
        let cellHeight = 60

        guard count != 0 else {
            lapTableView.snp.remakeConstraints { make in
                make.top.equalTo(paceTitleLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalTo(scrollView.contentView)
                make.bottom.equalTo(scrollView.contentView)
            }
            return
        }
        
        let maxSize = CGFloat(count) * CGFloat(cellHeight)
        lapTableView.snp.remakeConstraints { make in
            make.top.equalTo(paceTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(scrollView.contentView)
            make.height.equalTo(maxSize)
        }
    }
}

// MARK: - TableView Delegate & DataSource
extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.laps.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Legend
        if indexPath.row == 0 {
            let cell = LapSplitCell()
            cell.setLegend()
            return cell
        }
        
        // Lap Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LapSplitCell.reuseId, for: indexPath) as? LapSplitCell else {return UITableViewCell()}
        cell.backgroundColor = AppUIColor.skyBackground
        let data = self.data
        cell.setData(lapData: data.laps[indexPath.row - 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
