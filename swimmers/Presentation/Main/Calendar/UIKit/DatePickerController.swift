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
    }
    
}

extension DatePickerController {
    
    private func configure() {
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.register(DatePickerReuseCell.self,
                                   forCellWithReuseIdentifier: DatePickerReuseCell.identifier)
        
        dateRecordListView.getTableView().delegate = self
        dateRecordListView.getTableView().dataSource = self
        dateRecordListView.getTableView().register(SwimRecordSmallCell.self,
                                                   forCellReuseIdentifier: SwimRecordSmallCell.reuseId)
        
        loadingIndicator.center = view.center
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
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                print("Monthly Toggle 버튼 눌러짐")
                self?.dateRecordListView.monthlyToggleButtonAction()
            }
            .store(in: &cancellables)
        
        viewModel.$currentDate
            .receive(on: RunLoop.main)
            .sink { event in
                print("CurrentDate 변경 \(event)")
                self.dateRecordListView.getTableView().reloadData()
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
        return viewModel.extractDayInCarendar().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerReuseCell.identifier, for: indexPath) as? DatePickerReuseCell else {return UICollectionViewCell() }
        
        let calendar = viewModel.extractDayInCarendar()[indexPath.item]
        cell.viewModel = self.viewModel
        cell.setDateValue(calendar)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentDate = viewModel.extractDayInCarendar()[indexPath.item].date
        viewModel.currentDate = currentDate
        viewModel.isMonthlyRecord = false
        
        if let selectedIndexPath = selectedIndexPath {
            let cell = collectionView.cellForItem(at: selectedIndexPath) as! DatePickerReuseCell
            cell.hiddenCircle(true)
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
        
        self.selectedIndexPath = indexPath
        
        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerReuseCell
        cell.hiddenCircle(false)
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
        if viewModel.presentedEventData.count == 0 {
            return 0
        } else {
            return viewModel.extractSelectedDateEvent()?.event.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SwimRecordSmallCell.reuseId,
                                                       for: indexPath) as? SwimRecordSmallCell else { return UITableViewCell() }
        guard let swimData = viewModel.extractSelectedDateEvent()?.event[indexPath.row] else {
            let cell = UITableViewCell()
            // TODO: 여기에 PlaceHolder -> 이 날의 운동기록이 없습니다 표시.
            return cell
        }
        cell.updateData(swimData)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        return nil
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

