//
//  PickerModalViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/8/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityDatePicker: BaseViewController {
    
    private let viewModel: ActivityDatePickerViewModel
    
    private lazy var leftPicker = createPickerView()
    private lazy var rightPicker = createPickerView()

    private lazy var hstack = ViewFactory.hStack()
        .distribution(.fillProportionally)
        .addSubviews([leftPicker, rightPicker])
    
    lazy var applyButton = ViewFactory
        .label("확인")
        .font(.custom(.sfProMedium, size: 18))
        .foregroundColor(.white)
        .textAlignemnt(.center)
        .cornerRadius(16)
        .backgroundColor(AppUIColor.primaryBlue)
    
    private let pickerCount: Int
    
    private var viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private var segmentChangedSubject = CurrentValueSubject<ActivityDataRange, Never>(.monthly)
    var dateSubject = CurrentValueSubject<Date, Never>(Date())

    // MARK: - Init
    init(viewModel: ActivityDatePickerViewModel, pickerCount: Int = 1) {
        self.viewModel = viewModel
        self.pickerCount = pickerCount
        super.init()
        self.viewModel.setMonthOfWeekNumber()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        layout()
    }

    // MARK: - Setup
    private func bind() {
        
        let input = ActivityDatePickerViewModel
            .Input(viewWillAppeared: viewWillAppearSubject.eraseToAnyPublisher(),
                   dateChanged: dateSubject.eraseToAnyPublisher(),
                   segmentChanged: segmentChangedSubject.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.changePicker
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] segmentIndex in
                self.setSegmentIndex(segmentIndex)
            }
            .store(in: &cancellables)
    }
    
    private func configure() {
        self.modalPresentationStyle = .automatic
        let sheet = self.sheetPresentationController
        sheet?.detents = [.medium()]
        sheet?.prefersGrabberVisible = true
    }
    
    private func layout() {
        view.addSubview(hstack)
        view.backgroundColor = .systemBackground
        hstack.backgroundColor = .systemBackground
        hstack.sizeToFit()
        
        let modalHeight = AppConstant.deviceSize.height / 2
        let pickerHeight = modalHeight * 0.5

        hstack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(pickerHeight)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(hstack.snp.bottom).offset(16)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
        
    }
    
    // MARK: - Helpers
        
    private func isHideRightPicker(_ value: IsHidden = .hide) {
        rightPicker.isHidden = value.boolType
    }
    
    private func createPickerView() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        return pickerView
    }
    
    func setSegmentIndex(_ index: ActivityDataRange) {
        self.segmentChangedSubject.send(index)
    }
    
    // MARK: Picker State
    func selectCurrentIndex(selectedDate: Date) {
        switch segmentChangedSubject.value {
        case .weekly:
            isHideRightPicker(.hide)
            selectCurrentWeek()
        case .monthly:
            isHideRightPicker(.show)
            selectCurrentYear(selectedDate: selectedDate)
        case .yearly:
            isHideRightPicker(.hide)
            selectCurrentYear(selectedDate: selectedDate)
        case .total:
            isHideRightPicker(.hide)
        }
    }
    
    /// Picker로 선택한 연도의  index를 찾아 선택
    private func selectCurrentYear(selectedDate: Date) {
        let currentDay = selectedDate
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
    
    /// Picker로 선택한 주의 index를 찾아 선택
    private func selectCurrentWeek() {
        
        if let initialWeeksRow = viewModel.pickerWeeks.firstIndex(of: viewModel.leftString) ?? viewModel.pickerWeeks.firstIndex(of: "이번 주") {
            viewModel.leftString = viewModel.pickerWeeks[initialWeeksRow]
            leftPicker.selectRow(initialWeeksRow, inComponent: 0, animated: false)
        }

    }

}
// MARK: - PickerView Delegate
extension ActivityDatePicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedSegment = self.segmentChangedSubject.value
        
        if pickerView == leftPicker {
            switch selectedSegment {
            case .weekly:
                viewModel.leftString = viewModel.pickerWeeks[row]
            case .monthly:
                viewModel.leftString = viewModel.pickerYears[row]
            case .yearly:
                viewModel.leftString = viewModel.pickerYears[row]
            default:
                print("Changed")
            }
        }
        
        if pickerView == rightPicker {
            switch selectedSegment {
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
        
        let selectedSegmentIndex = segmentChangedSubject.value
        
        if pickerView == leftPicker {
            switch selectedSegmentIndex {
            case .weekly:
                return viewModel.pickerWeeks.count
            case .monthly:
                return viewModel.pickerYears.count
            case .yearly:
                return viewModel.pickerYears.count
            default:
                return 1
            }
        }
        
        if pickerView == rightPicker {
            switch selectedSegmentIndex {
            case .monthly:
                return viewModel.pickerMonths.count
            default:
                return 0
            }
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let selectedSegmentIndex = segmentChangedSubject.value

        if pickerView == leftPicker {
            switch selectedSegmentIndex {
            case .weekly:
                return viewModel.pickerWeeks[row]
            case .monthly:
                return "\(viewModel.pickerYears[row])년"
            case .yearly:
                return "\(viewModel.pickerYears[row])년"
            default:
                return "미구현"
            }
        }
        
        if pickerView == rightPicker {
            switch selectedSegmentIndex {
            case .monthly:
                return "\(viewModel.pickerMonths[row])월"
            default:
                return nil
            }
        }
        
        return nil
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct ActivityDatePicker_Previews: PreviewProvider {
    
    static let viewController = ActivityDatePicker(viewModel: viewModel)
    static let viewModel = ActivityDatePickerViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
