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
    private let loadingIndicator = LoadingIndicator()
    private var isFirstRun = true
    
    private lazy var workoutDatePicker = DatePickerHeader(viewModel: viewModel)
    private lazy var dayCollectionView = DatePickerCollectionView(viewModel: viewModel)
    private lazy var dateRecordListView = DateRecordListView(viewModel: viewModel)
    
    init(viewModel: DatePickerViewModel = .init()) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDatePickerLayout()
        self.navigationItem.title = "수영 캘린더"
        self.hideNavigationBar(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar(true)
    }
    
}

extension DatePickerController {
    
    private func configure() {
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.register(DatePickerDayCell.self,
                                   forCellWithReuseIdentifier: DatePickerDayCell.identifier)
        
        dateRecordListView.getTableView().delegate = self
        dateRecordListView.getTableView().dataSource = self
        dateRecordListView.getTableView().register(RecordSmallCell.self,
                                                   forCellReuseIdentifier: RecordSmallCell.reuseId)
    }
    
    private func layout() {
        self.view.addSubview(workoutDatePicker)
        self.view.addSubview(dayCollectionView)
        self.view.addSubview(dateRecordListView)
        self.view.addSubview(loadingIndicator)
        
        workoutDatePicker.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        dayCollectionView.setContentCompressionResistancePriority(.init(751), for: .vertical)
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(workoutDatePicker.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        dateRecordListView.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(30)
        }
    }
    
    private func updateDatePickerLayout() {
        
        dayCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(workoutDatePicker.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalTo(view)
            make.height.equalTo(self.viewModel.getCellSize().width * 6)
        }
        
    }
    
    private func bind() {
        viewModel.$currentMonth
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.changeMonth()
                self?.workoutDatePicker.updateView()
                self?.dayCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        dateRecordListView.getMothlyToggleButton()
            .gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.isMonthlyRecord.toggle()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.dateRecordListView.getTableView().reloadData()
            }
            .store(in: &cancellables)
        
        Task {
            self.loadingIndicator.show()
            await viewModel.subscribeSwimData()
            self.dayCollectionView.reloadData()
            self.loadingIndicator.hide()
        }
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
        return viewModel.getCellSize()
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
    
    func createSwimRecordSmallCell(data: [SwimMainData]? ,tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
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
        
        let detailVC = RecordDetailViewController(data: data)
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
