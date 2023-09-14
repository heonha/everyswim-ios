//
//  WorkoutDatePickerController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit
import Combine

final class WorkoutDatePickerController: UIViewController {
    
    private let viewModel: EventDatePickerViewModel
    private var cancellables: Set<AnyCancellable>
    
    private lazy var workoutDatePicker = WorkoutDatePicker(viewModel: viewModel)
    private lazy var dayCollectionView = DatePickerCollectionView()
    
    init(viewModel: EventDatePickerViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await viewModel.subscribeSwimData() }
    }
    
    private func configure() {
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
    }
    
    private func layout() {
        self.view.addSubview(workoutDatePicker)
        self.view.addSubview(dayCollectionView)
        
        workoutDatePicker.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(workoutDatePicker.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    private func bind() {
        
        viewModel.$currentMonth
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.changeMonth()
            }
            .store(in: &cancellables)
        
    }
    
}


extension WorkoutDatePickerController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.extractDayInCarendar().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DatePickerCell(viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.currentDate = viewModel.extractDayInCarendar()[indexPath.item].date
        viewModel.isMonthlyRecord = false
    }
    
}

#if DEBUG
import SwiftUI

struct WorkoutDatePickerController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            WorkoutDatePickerController(viewModel: EventDatePickerViewModel())
        }
        .ignoresSafeArea()
    }
}
#endif

