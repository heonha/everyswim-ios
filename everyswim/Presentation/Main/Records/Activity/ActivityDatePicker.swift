//
//  PickerModalViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/8/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityDatePicker: UIViewController, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()

    private let viewModel: ActivityViewModel
    
    private lazy var leftPicker = createPickerView()
    private lazy var rightPicker = createPickerView()

    private lazy var hstack = ViewFactory.hStack()
        .distribution(.fillProportionally)
        .addSubviews([leftPicker, rightPicker])
    
    private lazy var applyButton = ViewFactory.label("확인")
        .font(.custom(.sfProMedium, size: 18))
        .foregroundColor(.white)
        .textAlignemnt(.center)
        .backgroundColor(AppUIColor.primaryBlue)
    
    private let pickerCount: Int
    
    init(viewModel: ActivityViewModel, pickerCount: Int = 1) {
        self.viewModel = viewModel
        self.pickerCount = pickerCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        switch viewModel.selectedSegment {
        case .weekly:
            isHideRightPicker(.hide)
        case .monthly:
            isHideRightPicker(.show)
            selectCurrentYear()
        case .yearly:
            isHideRightPicker(.hide)
            selectCurrentYear()
        case .total:
            isHideRightPicker(.hide)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    
    // MARK: - Setup
    
    private func configure() {
        self.modalPresentationStyle = .automatic
        let sheet = self.sheetPresentationController
        sheet?.detents = [.medium()]
        sheet?.prefersGrabberVisible = true
    }
    
    private func layout() {
        view.addSubview(hstack)
        view.backgroundColor = .systemBackground
        hstack.backgroundColor = .systemGray4
        hstack.sizeToFit()
        hstack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(hstack.snp.bottom).offset(16)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
        }
        
    }

    private func bind() {
        applyButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                viewModel.setSelectedDate(left: viewModel.leftString, right: viewModel.rightString)
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helpers
    private func setFirstPickedData() {
        if viewModel.selectedSegment == .weekly {
            let date = Date()
            viewModel.leftString = date.toString(.year)
            viewModel.rightString = date.toString(.monthFull)
        }
    }
        
    private func isHideRightPicker(_ value: IsHidden = .hide) {
        rightPicker.isHidden = value.boolType
    }
    
    private func createPickerView() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        return pickerView
    }
    
    private func selectCurrentYear() {
        let currentDay = viewModel.selectedDate
        let currentYear = Calendar.current.component(.year, from: currentDay)
        
        var currentMonth: String {
            let month = Calendar.current.component(.month, from: currentDay)
            
            if month < 10 {
                return "0\(month)"
            } else {
                return "\(month)"
            }
        }
        
        if let initialYearRow = viewModel.pickerYears.firstIndex(of: "\(currentYear)") {
            viewModel.leftString = viewModel.pickerYears[initialYearRow]
            leftPicker.selectRow(initialYearRow, inComponent: 0, animated: false)
        }
        
        if let initialMonthRow = viewModel.pickerMonths.firstIndex(of: currentMonth) {
            viewModel.rightString = viewModel.pickerMonths[initialMonthRow]
            rightPicker.selectRow(initialMonthRow, inComponent: 0, animated: false)
        }

    }

}
// MARK: - PickerView Delegate
extension ActivityDatePicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == leftPicker {
            switch viewModel.selectedSegment {
            case .monthly:
                viewModel.leftString = viewModel.pickerYears[row]
            case .yearly:
                viewModel.leftString = viewModel.pickerYears[row]
            default:
                print("Changed")
            }
        }
        
        if pickerView == rightPicker {
            switch viewModel.selectedSegment {
            case .monthly:
                viewModel.rightString = viewModel.pickerMonths[row]
            default:
                print("rightError")
            }
        }
        
    }
}

// MARK: - PickerView DataSource
extension ActivityDatePicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == leftPicker {
            switch viewModel.selectedSegment {
            case .monthly:
                return viewModel.pickerYears.count
            case .yearly:
                return viewModel.pickerYears.count
            default:
                return 1
            }
        }
        
        if pickerView == rightPicker {
            switch viewModel.selectedSegment {
            case .monthly:
                return viewModel.pickerMonths.count
            default:
                return 0
            }
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == leftPicker {
            switch viewModel.selectedSegment {
            case .monthly:
                return "\(viewModel.pickerYears[row])년"
            case .yearly:
                return "\(viewModel.pickerYears[row])년"
            default:
                return "미구현"
            }
        }
        
        if pickerView == rightPicker {
            switch viewModel.selectedSegment {
            case .monthly:
                return "\(viewModel.pickerMonths[row])월"
            default:
                return nil
            }
        }
        
        return nil
    }
    
}
