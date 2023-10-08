//
//  PickerModalViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/8/23.
//

import UIKit
import SnapKit
import Combine

final class PickerModalViewController: UIViewController {
    
    private var years = [String]()
    private var months = [String]()
    
    private let viewModel: ActivityViewModel
    
    private lazy var leftPicker = createPickerView()
    private lazy var rightPicker = createPickerView()
    private lazy var hstack = ViewFactory.hStack()
        .distribution(.fillProportionally)
        .addSubviews([leftPicker, rightPicker])
    
    private let pickerCount: Int
    
    init(viewModel: ActivityViewModel, pickerCount: Int = 1) {
        self.viewModel = viewModel
        self.pickerCount = pickerCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleData()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func createPickerView() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        return pickerView
    }
    
    private func configure() {
        self.modalPresentationStyle = .popover
        let sheet = self.sheetPresentationController
        sheet?.detents = [.medium()]
        sheet?.prefersGrabberVisible = true
    }
    
    private func setTitleData() {
        
        for year in 2020...2023 {
            years.append("\(year)년")
        }
        
        for month in 1...12 {
            months.append("\(month)월")
        }
        
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
    }

    private func isHideRightPicker(_ value: IsHidden = .hide) {
        rightPicker.isHidden = value.boolType
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        print("DISMISS")
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        switch viewModel.selectedSegment {
        case .daily:
            isHideRightPicker(.hide)
        case .weekly:
            isHideRightPicker(.hide)
        case .monthly:
            isHideRightPicker(.show)
        case .lifetime:
            isHideRightPicker(.hide)
        }
    }
    
}
// MARK: - PickerView Protocols
extension PickerModalViewController: UIPickerViewDelegate {
    
}

extension PickerModalViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == leftPicker {
            switch viewModel.selectedSegment {
            case .daily:
                return viewModel.days.count
            case .weekly:
                return viewModel.weeks.count
            case .monthly:
                return viewModel.months.count
            case .lifetime:
                return viewModel.year.count
            }
        }
        
        if pickerView == rightPicker {
            switch viewModel.selectedSegment {
            case .daily:
                return 1
            case .weekly:
                return 1
            case .monthly:
                return 1
            case .lifetime:
                return 1
            }
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == leftPicker {
            switch viewModel.selectedSegment {
            case .daily:
                return viewModel.days[row].toString(.fullDotDate)
            case .weekly:
                return "\(viewModel.weeks[row].toStringWeekNumber())주차"
            case .monthly:
                return viewModel.months[row].toString(.yearMonth)
            case .lifetime:
                return viewModel.year[row].toString(.year)
            }
        }
        
        if pickerView == rightPicker {
            switch viewModel.selectedSegment {
            case .daily:
                return "right daily"
            case .weekly:
                return "right weekly"
            case .monthly:
                return "right monthly"
            case .lifetime:
                return "right year"
            }
        }
        
        return nil
    }
    
}


enum IsHidden {
    case show
    case hide
    
    var boolType: Bool {
        switch self {
        case .show:
            return false
        case .hide:
            return true
        }
    }
}
