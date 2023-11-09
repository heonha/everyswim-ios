//
//  ActivityViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityViewController: UIViewController, CombineCancellable {
    
    private let viewModel: ActivityViewModel
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let scrollView = BaseScrollView()
    
    private lazy var segmentControl = ActivityTypeSegmentControl(viewModel: viewModel)
    
    private let titleLabel = ViewFactory.label("이번 주")
        .font(.custom(.sfProBold, size: 17))
        .foregroundColor(.secondaryLabel)
    
    private let titleLabelSybmol = UIImageView()
        .setSymbolImage(systemName: "chevron.down", color: AppUIColor.grayTint)
        .contentMode(.scaleAspectFit)
        .setSize(width: 20, height: 20)
    
    private lazy var titleMenu = ViewFactory.hStack()
        .addSubviews([titleLabel, titleLabelSybmol])
        .spacing(4)
        .alignment(.center)
        .distribution(.fillProportionally)
    
    private lazy var distanceStack = DistanceBigLabel()
    
    private lazy var recordHStack = RecordHStackView()
    
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
        
    private lazy var tableView = BaseTableView()

    // 주간 활동
    private lazy var activitySectionView = ActivitySectionView()

    
    // MARK: - Initializer
    init(viewModel: ActivityViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        bind()
        viewModel.updateDate()
        viewModel.selectedSegment = .monthly
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideNavigationBar(false)
    }
    // 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    
    // MARK: - Configure & Layout
    private func configure() {
        
        configureScrollView()
        
        // Navigation
        self.navigationItem.title = "수영 기록"
        
        // 이번주 기록 가져오기
        recordHStack.setData(viewModel.summaryData)
    }
    
    private func configureScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordMediumCell.self, forCellReuseIdentifier: RecordMediumCell.reuseId)
        tableView.backgroundColor = AppUIColor.skyBackground
        tableView.isScrollEnabled = false
    }
    
    private func layout() {
        view.addSubview(scrollView)
        let contentView = scrollView.contentView
        contentView.addSubview(mainVStack)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
                
        mainVStack.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.horizontalEdges.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        distanceStack.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(32)
            make.height.equalTo(30)
        }

        recordHStack.snp.makeConstraints { make in
            make.width.equalTo(mainVStack).inset(30)
            make.height.equalTo(70)
        }
       
        contentView.addSubview(activitySectionView)
        
        activitySectionView.snp.makeConstraints { make in
            make.top.equalTo(recordHStack.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        activitySectionView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(activitySectionView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        

    }
    
    // MARK: - Bind (Subscribers)
    private func bind() {
        bindSegmentButtons()
        bindSummaryData()
        bindPresentedData()
        bindTitleMenu()
        bindSelectedDate()
        bindScrollViewSwipe()
    }
    
    private func bindSelectedDate() {
        viewModel.$selectedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self else {return}
                updateTitles(tag: viewModel.selectedSegment, date: date)
            }
            .store(in: &cancellables)
    }
    
    private func bindSegmentButtons() {
        viewModel.$selectedSegment
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tag in
                guard let self = self else { return }
                titleLabelSybmol.isHidden = false
                updateTitles(tag: tag)
            }
            .store(in: &cancellables)
        
    }
    
    /// Segment를 Swipe로 변경하는 Gesture Action
    private func bindScrollViewSwipe() {
        scrollView
            .gesturePublisher(.swipe(.init(), direction: .left))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.leftSwipeAction()
            }
            .store(in: &cancellables)
        
        scrollView
            .gesturePublisher(.swipe(.init(), direction: .right))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rightSwipeAction()
            }
            .store(in: &cancellables)

    }

    private func bindTitleMenu() {
        titleMenu.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                if viewModel.selectedSegment == .total { return }
                let vc = ActivityDatePicker(viewModel: self.viewModel)
                self.present(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindSummaryData() {
        viewModel.$summaryData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.distanceStack.setData(data?.distance, unit: data?.distanceUnit ?? "")
                self?.recordHStack.setData(data)
            }
            .store(in: &cancellables)
    }
    
    private func bindPresentedData() {
        viewModel.$presentedData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.tableView.reloadData()
                self?.updateTableViewSize()
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
    
    // MARK: - Appearances
    
    /// Cell 갯수에 따라서 TableView 크기를 업데이트
    /// (Scrollview In Scrollview이기 때문에 tableView의 ContentSize를 유동적으로 변화하게함)
    func updateTableViewSize() {
        let count = viewModel.presentedData.count
        let cellHeight = 180.0
        
        guard count != 0 else {
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(activitySectionView.snp.bottom)
                make.horizontalEdges.equalTo(scrollView.contentView)
                make.bottom.equalTo(scrollView.contentView)
            }
            
            return
        }
        
        let maxSize = CGFloat(count) * cellHeight
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(activitySectionView.snp.bottom)
            make.horizontalEdges.equalTo(scrollView.contentView)
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
    
}

// MARK: - TableView Delegate
extension ActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // RecordMediumCell 높이
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? RecordMediumCell else {return}
        let data = cell.getData()
        let detailVC = RecordDetailViewController(data: data)
        self.push(detailVC, animated: true)
    }
    
}

// MARK: - TableView datasource
extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.presentedData.isEmpty {
            return 1
        } else {
            return viewModel.presentedData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.presentedData.isEmpty {
            return EmptyRecordCell.withType(.normal)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordMediumCell.reuseId, for: indexPath) as? RecordMediumCell else {
            return EmptyRecordCell()
        }
        
        let data = viewModel.presentedData[indexPath.row]
        cell.setData(data)
        return cell
    }
    
}


// MARK: - Previewer
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
