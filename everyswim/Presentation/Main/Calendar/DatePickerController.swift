//
//  DatePickerController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit
import Combine

final class DatePickerController: UIViewController {
    
    private let viewModel: DatePickerViewModel
    private var cancellables: Set<AnyCancellable>
    private var selectedIndexPath: IndexPath?
    private let loadingIndicator = ActivityIndicator()
    private var isFirstRun = true
    
    private lazy var pickerHeader = DatePickerHeader(viewModel: viewModel)
    private lazy var dayView = DatePickerCollectionView(viewModel: viewModel)
    private lazy var recordListView = DateRecordListView(viewModel: viewModel)
    
    init(viewModel: DatePickerViewModel = .init()) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "수영 캘린더"
        updateDatePickerLayout()
        getDataTasks()
    }
    
}

extension DatePickerController {
    
    private func configure() {
        configureDayView()
        configureRecordListView()
    }
    
    /// 날짜 CollectionView 구성
    private func configureDayView() {
        dayView.delegate = self
        dayView.dataSource = self
        dayView.register(DatePickerDayCell.self,
                                   forCellWithReuseIdentifier: DatePickerDayCell.identifier)
        addSwipeForDayView()
    }
    
    /// 수영 기록 뷰 구성
    private func configureRecordListView() {
        recordListView.getTableView().delegate = self
        recordListView.getTableView().dataSource = self
        recordListView.getTableView().register(RecordSmallCell.self,
                                                   forCellReuseIdentifier: RecordSmallCell.reuseId)
    }
    
    /// DayView의 Swipe로 달력 전환 제스쳐 추가.
    private func addSwipeForDayView() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        leftSwipeGesture.direction = .left
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        rightSwipeGesture.direction = .right

        dayView.gestureRecognizers?.append(leftSwipeGesture)
        dayView.gestureRecognizers?.append(rightSwipeGesture)
    }
    
    /// Swipe Action: 다음 월
    @objc func leftSwipeAction() {
        viewModel.changeCurrentMonth(.increase)
    }
    
    /// Swipe Action: 이전 월
    @objc func rightSwipeAction() {
        viewModel.changeCurrentMonth(.decrease)
    }
    
    private func layout() {
        self.view.addSubview(pickerHeader)
        self.view.addSubview(dayView)
        self.view.addSubview(recordListView)
        self.view.addSubview(loadingIndicator)
        
        pickerHeader.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        dayView.setContentCompressionResistancePriority(.init(751), for: .vertical)
        dayView.snp.makeConstraints { make in
            make.top.equalTo(pickerHeader.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        recordListView.snp.makeConstraints { make in
            make.top.equalTo(dayView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(30)
        }
    }
    
    private func updateDatePickerLayout() {
        dayView.snp.remakeConstraints { make in
            make.top.equalTo(pickerHeader.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalTo(view)
            make.height.equalTo(self.viewModel.getSizeForDayCell().width * 6)
        }
    }
    
    private func getDataTasks() {
        viewModel.refreshCalendar()
        viewModel.setTargetMonthData()
        pickerHeader.updateView()
        dayView.reloadData()
    }
    
    private func bind() {
        viewModel.$currentMonth
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                viewModel.refreshCalendar()
                pickerHeader.updateView()
                dayView.reloadData()
            }
            .store(in: &cancellables)
        
        recordListView.getMothlyToggleButton()
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.isMonthlyRecord.toggle()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.recordListView.getTableView().reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$dataInSelectedMonth
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dayView.reloadData()
            }
            .store(in: &cancellables)

    }
    
}

extension DatePickerController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dayInCarendar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerDayCell.identifier, for: indexPath) as? DatePickerDayCell else { return UICollectionViewCell() }
        
        let dateValue = viewModel.dayInCarendar[indexPath.item]
        cell.viewModel = self.viewModel
        cell.dateValue = dateValue
        cell.isShadowHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = viewModel.dayInCarendar[indexPath.item].date
        viewModel.selectedDate = selectedDate
        viewModel.isMonthlyRecord = false
        HapticManager.triggerHapticFeedback(style: .soft)
        if let selectedIndexPath = selectedIndexPath {
            let cell = collectionView.cellForItem(at: selectedIndexPath) as! DatePickerDayCell
            cell.isShadowHidden = true
            collectionView.reloadItems(at: [selectedIndexPath])
        }
        
        self.selectedIndexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerDayCell
        cell.isShadowHidden = false
    }
}

extension DatePickerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getSizeForDayCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
}

extension DatePickerController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isMonthlyRecord {
            
            let events = viewModel.dataInSelectedMonth
                .flatMap { data in
                    return data.event
                }
            if events.isEmpty {
                return 1
            } else {
                return events.count
            }
            
        } else {
            if viewModel.hasEvent(date: viewModel.selectedDate) {
                if let hasData = viewModel.extractDailyData() {
                    return hasData.event.count
                }
                
                return 1
            }
            
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.isMonthlyRecord {
            let monthlyData = viewModel.dataInSelectedMonth
                .flatMap { data in
                    return data.event
                }

            if monthlyData.isEmpty {
                return EmptyRecordCell.withType(.monthly)
            } else {
                return createSwimRecordSmallCell(data: monthlyData, tableView: tableView, indexPath: indexPath)
            }
            
        } else {
            guard viewModel.hasEvent(date: viewModel.selectedDate) else { return EmptyRecordCell.withType(.daily) }
            
            let dailyData = viewModel.extractDailyData()
            
            return createSwimRecordSmallCell(data: dailyData?.event, tableView: tableView, indexPath: indexPath)
        }
    }
    
    func createSwimRecordSmallCell(data: [SwimMainData]?,
                                   tableView: UITableView,
                                   indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = data else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordSmallCell.reuseId,
                                                       for: indexPath) as? RecordSmallCell else { return UITableViewCell() }
        let swimData = data[indexPath.row]
        cell.updateData(swimData)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.dataInSelectedMonth.isEmpty {
            return tableView.frame.height
        } else {
            if !viewModel.hasEvent(date: viewModel.selectedDate) {
                if !viewModel.isMonthlyRecord {
                    return tableView.frame.height
                }
            }
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? RecordSmallCell else { return }
        guard let data = cell.data else { return }
        
        let detailVC = ActivityDetailViewController(data: data)
        self.push(detailVC, animated: true)
    }
    
}

#if DEBUG
import SwiftUI

struct WorkoutDatePickerController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DatePickerController(viewModel: DatePickerViewModel())
        }
        .ignoresSafeArea()
    }
}
#endif
