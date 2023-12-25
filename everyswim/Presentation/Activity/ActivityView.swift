//
//  ActivityView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/23/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityView: BaseScrollView {
        
    private weak var parentVC: ActivityViewController?
    
    private let viewModel: ActivityViewModel
    
    private lazy var segmentControl = ActivityTypeSegmentControl(viewModel: viewModel)
    
    private lazy var activitySectionView = ActivitySectionView()

    private var layoutLoaded = false
    
    let titleLabel = ViewFactory
        .label("이번 주")
        .font(.custom(.sfProBold, size: 17))
        .foregroundColor(.secondaryLabel)
    
    let titleLabelSybmol = UIImageView()
        .setSymbolImage(systemName: "chevron.down", color: AppUIColor.grayTint)
        .contentMode(.scaleAspectFit)
        .setSize(width: 20, height: 20)
    
    lazy var titleMenu = ViewFactory.hStack()
        .addSubviews([titleLabel, titleLabelSybmol])
        .spacing(4)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    private lazy var distanceStack = DistanceLargeLabel()
    
    private lazy var recordHStack = ActivityDetailCenterDataView()
    
    private lazy var recordMainStack = ViewFactory.vStack()
        .addSubviews([titleMenu, distanceStack, recordHStack])
        .spacing(30)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    private lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([segmentControl, recordMainStack])
        .spacing(30)
        .alignment(.center)
        .distribution(.fillProportionally)
        
    lazy var tableView = BaseTableView()
    
    // MARK: - INIT
    init(viewModel: ActivityViewModel, parentVC: ActivityViewController?) {
        self.viewModel = viewModel
        self.parentVC = parentVC
        super.init()
        configure()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        if !layoutLoaded {
            layoutLoaded = true
            remakeTableViewSize()
        }
    }
    
    // MARK: - Configure
    private func configure() {
        viewModel.updateDate()
        viewModel.selectedSegment = .monthly
        
        // ScrollView
        configureScrollView()
        
        // TableView
        configureTableView()
        
        // 이번주 기록 가져오기
        recordHStack.setData(viewModel.summaryData)
        
    }
    
    private func configureScrollView() {
        isScrollEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

    private func configureTableView() {
        tableView.delegate = parentVC
        tableView.dataSource = parentVC
        tableView.register(RecordMediumCell.self, forCellReuseIdentifier: RecordMediumCell.reuseId)
        tableView.backgroundColor = AppUIColor.skyBackground
        tableView.isScrollEnabled = false
    }
    
    // MARK: - Observe
    private func observe() {
        observeScrollViewSwipe()
        observeSegmentButtons()
        observePresentedData()
        observeSelectedDate()
        observeSummaryData()
    }
    
    private func observeSegmentButtons() {
        viewModel.$selectedSegment
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tag in
                guard let self = self else { return }
                titleLabelSybmol.isHidden = false
                updateTitles(tag: tag)
            }
            .store(in: &cancellables)
    }
    
    private func observeScrollViewSwipe() {
        gesturePublisher(.swipe(.init(), direction: .left))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.leftSwipeAction()
            }
            .store(in: &cancellables)
        
        gesturePublisher(.swipe(.init(), direction: .right))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rightSwipeAction()
            }
            .store(in: &cancellables)
    }
    
    private func observePresentedData() {
        viewModel.$presentedData
            .filter { [weak self] _ in
                return self?.layoutLoaded ?? false
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateTableViewSize()
            }
            .store(in: &cancellables)
    }
    
    private func observeSummaryData() {
        viewModel.$summaryData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.distanceStack.setData(data?.distance, unit: data?.distanceUnit ?? "")
                self?.recordHStack.setData(data)
            }
            .store(in: &cancellables)
    }
    
    private func observeSelectedDate() {
        viewModel.$selectedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self else {return}
                updateTitles(tag: viewModel.selectedSegment, date: date)
            }
            .store(in: &cancellables)
    }

    // MARK: - Swipe Gestures & Actions
    @objc private func leftSwipeAction() {
        let currentValue = viewModel.selectedSegment.rawValue
        if currentValue == 3 { return }
        let newValue = currentValue + 1
        segmentControl.selectSegment(index: newValue)
        HapticManager.triggerHapticFeedback(style: .rigid)
    }
    
    @objc private func rightSwipeAction() {
        let currentValue = viewModel.selectedSegment.rawValue
        if currentValue == 0 { return }
        let newValue = currentValue - 1
        segmentControl.selectSegment(index: newValue)
        HapticManager.triggerHapticFeedback(style: .rigid)
    }
    
    /// 테이블 뷰 사이즈 업데이트 (Cell의 수에 따라)
    private func updateTableViewSize() {
        self.tableView.reloadData()
        self.remakeTableViewSize()
    }
    
    /// Cell 갯수에 따라서 TableView 크기를 업데이트
    /// (Scrollview In Scrollview이기 때문에 tableView의 ContentSize를 유동적으로 변화하게함)
    func remakeTableViewSize() {
        let count = viewModel.presentedData.count
        let cellHeight: CGFloat = 121.0
        
        guard count != 0 else {
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(activitySectionView.snp.bottom)
                make.horizontalEdges.equalTo(contentView)
                make.bottom.equalTo(contentView)
            }
            return
        }
        
        var maxSize = CGFloat(count) * cellHeight
        if maxSize <= AppConstant.deviceSize.height / 2.5 {
            maxSize = AppConstant.deviceSize.height / 2.5
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(activitySectionView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(maxSize)
        }
    }
    
    /// 상단 ----년의 기록 타이틀 업데이트
    private func updateTitles(tag: ActivityDataRange, date: Date = Date()) {
        switch tag {
        case .weekly:
            if viewModel.leftString.isEmpty {
                self.titleLabel.text = "이번 주"
                self.activitySectionView.updateTitle("이번 주 수영 기록")
            } else {
                self.titleLabel.text = viewModel.leftString
                self.activitySectionView.updateTitle("\(viewModel.leftString) 수영 기록")
            }
            self.titleLabelSybmol.isHidden = false
        case .monthly:
            let year = date.toString(.year)
            let month = date.toString(.monthKr)
            self.titleLabel.text = "\(year)년 \(month)"
            self.titleLabelSybmol.isHidden = false
            self.activitySectionView.updateTitle("\(year)년 \(month)의 수영")
            
        case .yearly:
            let year = date.toString(.year)
            self.titleLabel.text = "\(year)년 기록"
            self.titleLabelSybmol.isHidden = false
            self.activitySectionView.updateTitle("\(year)년의 수영")
            
        case .total:
            self.titleLabel.text = "전체 기록"
            self.titleLabelSybmol.isHidden = true
            self.activitySectionView.updateTitle("전체 수영기록")
        }
    }
    
    // MARK: - Layout
    private func layout() {
        layoutMainStackView()
        layoutSubStackView()
        layoutSegmentControll()
        layoutActivitySectionView()
        layoutTableView()
    }
    
    private func layoutActivitySectionView() {
        contentView.addSubview(activitySectionView)
        activitySectionView.snp.makeConstraints { make in
            make.top.equalTo(recordHStack.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        activitySectionView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    private func layoutSegmentControll() {
        segmentControl.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(32)
            make.height.equalTo(30)
        }
    }
    
    private func layoutMainStackView() {
        contentView.addSubview(mainVStack)
        mainVStack.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.horizontalEdges.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
    }
    
    private func layoutSubStackView() {
        // Distance Stack
        distanceStack.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        // RecordHStack
        recordHStack.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(30)
            make.height.equalTo(70)
        }
    }
    
    private func layoutTableView() {
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(activitySectionView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }

    }

}
