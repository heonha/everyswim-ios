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
    
    private let viewModel: EventDatePickerViewModel
    private var cancellables: Set<AnyCancellable>
    private var selectedIndexPath: IndexPath?
    
    private lazy var workoutDatePicker = DatePickerHeader(viewModel: viewModel)
    private lazy var dayCollectionView = DatePickerCollectionView(viewModel: viewModel)
    
    init(viewModel: EventDatePickerViewModel = .init()) {
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
        Task { await viewModel.subscribeSwimData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDatePickerLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func configure() {
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.register(DatePickerReuseCell.self, 
                                   forCellWithReuseIdentifier: DatePickerReuseCell.identifier)
    }
    
    private func layout() {
        self.view.addSubview(workoutDatePicker)
        self.view.addSubview(dayCollectionView)
        
        workoutDatePicker.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(workoutDatePicker.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func updateDatePickerLayout() {
        dayCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(workoutDatePicker.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(self.viewModel.getCellSize().width * 6)
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
        viewModel.currentDate = viewModel.extractDayInCarendar()[indexPath.item].date
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

#if DEBUG
import SwiftUI

struct WorkoutDatePickerController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DatePickerController(viewModel: EventDatePickerViewModel())
        }
        .ignoresSafeArea()
    }
}
#endif

