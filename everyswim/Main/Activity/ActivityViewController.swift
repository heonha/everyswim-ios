//
//  ActivityViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityViewController: BaseViewController {
    
    private let viewModel: ActivityViewModel
   
    private lazy var scrollView = ActivityScrollView()
    private lazy var contentView = scrollView.contentView
    
    private lazy var activityDatePickerViewModel = ActivityDatePickerViewModel()

    private lazy var segmentControl = ActivityTypeSegmentControl()
    
    private lazy var bottomSectionTitle = ActivitySectionView()

    private lazy var summaryView = ActivitySummaryView()
    
    private lazy var mainVStack = ViewFactory.vStack()
        .addSubviews([segmentControl, summaryView])
        .spacing(30)
        .alignment(.center)
        .distribution(.fillProportionally)
        
    private lazy var tableView = BaseTableView()
        
    // MARK: - Initializer
    init(viewModel: ActivityViewModel = .init()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.hideNavigationBar(false)
    }

    // MARK: - Configure & Layout
    private func configure() {
        // Navigation Title
        setNaviagationTitle(title: "수영 기록")
        
        // TableView
        configureTableView()
    }
    
    /// 테이블 뷰 사이즈 업데이트 (Cell의 수에 따라)
    private func reloadTableViewCellAndSize() {
        self.remakeTableViewSize()
        self.tableView.reloadData()
    }
    
    /// Cell 갯수에 따라서 TableView 크기를 업데이트
    /// (Scrollview In Scrollview이기 때문에 tableView의 ContentSize를 유동적으로 변화하게함)
    private func remakeTableViewSize() {
        let count = viewModel.presentedData.value.count
        let cellHeight: CGFloat = 121.0
        
        guard count != 0 else {
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(bottomSectionTitle.snp.bottom)
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
            make.top.equalTo(bottomSectionTitle.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(maxSize)
        }
    }
    
    // MARK: - Bind (Subscribers)
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordMediumCell.self, forCellReuseIdentifier: RecordMediumCell.reuseId)
        tableView.backgroundColor = AppUIColor.skyBackground
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
    }
    
    // swiftlint:disable:next function_body_length
    private func bind() {
        let input = ActivityViewModel.Input(
            viewWillAppeared: viewWillAppearPublisher.eraseToAnyPublisher(),
            selectedSegment: segmentControl.selectedSegmentIndexPublisher,
            tappedTitleMenu: summaryView.titleMenu.tapPublisher(),
            viewSwipedRight: scrollView.rightSwipePublisher,
            viewSwipedLeft: scrollView.leftSwipePublisher,
            scrollViewLayoutLoaded: scrollView.layoutLoaded.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)

        output.remakeTableViewLayout
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                remakeTableViewSize()
            }
            .store(in: &cancellables)
        
        output.updateSummaryData
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] data, range in
                summaryView.setSummaryData(data)
                summaryView.setTitle(range.segmentTitle)
                remakeTableViewSize()
            }
            .store(in: &cancellables)
        
        output.changeSegment
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] data in
                bottomSectionTitle.updateTitle(data.segmentTitle)
            }
            .store(in: &cancellables)
        
        output.updateLoadingState
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isLoading in
                print("LOADING STATE: \(isLoading)")
                if isLoading {
                    self.loadingIndicator.show()
                } else {
                    self.loadingIndicator.hide()
                }
            }
            .store(in: &cancellables)
        
        output.presentDatePicker
            .receive(on: DispatchQueue.main)
            .sink { dateRange, date in
                let viewModel = ActivityDatePickerViewModel()
                let vc = ActivityDatePickerViewController(viewModel: viewModel)
                vc.setDateRange(dateRange)
                vc.delegate = self
                self.present(vc, animated: true)
            }
            .store(in: &cancellables)
    }

    @objc func leftSwipeAction(selectedIndex: Int) {
        print("INDEX:\(selectedIndex)")
        segmentControl.selectedSegmentIndex = selectedIndex
        HapticManager.triggerHapticFeedback(style: .rigid)
    }
    
    @objc func rightSwipeAction(selectedIndex: Int) {
        segmentControl.selectedSegmentIndex = selectedIndex
        HapticManager.triggerHapticFeedback(style: .rigid)
    }

}

extension ActivityViewController: BaseDatePickerDelegate {
    
    func receivedData(data: Date) {
        
    }
    
}

// MARK: Configure
extension ActivityViewController {
    // MARK: - Swipe Gestures & Actions

}

// MARK: Layouts
extension ActivityViewController {
    
    private func layout() {
        self.view.addSubview(scrollView)
        self.view.addSubview(summaryView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        layoutMainStackView()
        layoutSegmentControll()
        layoutSummaryView()
        layoutActivitySectionView()
        layoutTableView()
        layoutLoadingIndicator(targetView: view)
    }
    
    private func layoutSummaryView() {
        summaryView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    private func layoutActivitySectionView() {
        contentView.addSubview(bottomSectionTitle)
        bottomSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(summaryView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        bottomSectionTitle.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
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

    private func layoutTableView() {
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bottomSectionTitle.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.height.greaterThanOrEqualTo(contentView).dividedBy(2)
            make.bottom.equalTo(contentView)
        }

    }
    
}

// MARK: - TableView Delegate
extension ActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? RecordMediumCell else {return}
        let data = cell.getData()
        let detailVC = ActivityDetailViewController(data: data)
        self.push(detailVC, animated: true)
    }
    
}

// MARK: - TableView datasource
extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.presentedData.value.isEmpty {
            return 1
        } else {
            return viewModel.presentedData.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.presentedData.value.isEmpty {
            let emptyCell = BaseEmptyTableViewCell()
            return emptyCell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordMediumCell.reuseId, 
                                                       for: indexPath) as? RecordMediumCell else { return EmptyRecordCell()
        }
        
        let data = viewModel.presentedData.value[indexPath.row]
        cell.setData(data)
        return cell
    }
    
}

// MARK: - Previewer
#if DEBUG
import SwiftUI

struct ActivityViewController_Previews: PreviewProvider {
    
    static let viewController = ActivityViewController(viewModel: viewModel)
    static let viewModel = ActivityViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
