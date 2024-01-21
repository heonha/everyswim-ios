//
//  PickerModalViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/8/23.
//

import UIKit
import SnapKit
import Combine

protocol ActivityDatePickerViewControllerDelegate: AnyObject {
    func receivedData(data: ActivityDatePickerViewData)
}

final class ActivityDatePickerViewController: BaseDatePickerViewcontroller {
    
    private let viewModel: ActivityDatePickerViewModel
    
    private lazy var applyButton = ViewFactory.buttonWithText1("적용")
    
    weak var delegate: ActivityDatePickerViewControllerDelegate?
    
    init(viewModel: ActivityDatePickerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        configureModal()
        datePicker.delegate = self
        datePicker.dataSource = self
        observe()
    }
    
    private func configureModal() {
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        layout()
    }
    
    func setDateRange(_ range: ActivityDataRange) {
        viewModel.getPickerComponents(range)
    }
    
    override func layout() {
        self.view.addSubview(datePicker)
        self.view.addSubview(applyButton)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(view).dividedBy(1.5)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        applyButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func selectPicker(to target: Date?, title: String? = "") {
        
        if self.viewModel.getDateRange() == .weekly {
            let title = title ?? "이번 주"
            guard let targetRow = viewModel.rows.value[0].firstIndex(of: title) else {return}
            self.datePicker.selectRow(targetRow, inComponent: 0, animated: false)
            return
        }
        
        let target = target ?? Date()
        let targetRowString = target.toString(.year)
        guard let targetRow = viewModel.rows.value[0].firstIndex(of: targetRowString) else {return}
        self.datePicker.selectRow(targetRow, inComponent: 0, animated: false)
        
        if self.viewModel.getDateRange() == .monthly {
            let targetRightRowString = target.toString(.month)
            guard let targetRow = viewModel.rows.value[1].firstIndex(of: targetRightRowString) else {return}
            self.datePicker.selectRow(targetRow, inComponent: 1, animated: false)
        }
    }
    
    private func observe() {
        self.applyButton.gesturePublisher()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
}

extension ActivityDatePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.components.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard !viewModel.components.value.isEmpty || !viewModel.rows.value.isEmpty  else { return 0 }
        return viewModel.rows.value[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard !viewModel.components.value.isEmpty || !viewModel.rows.value.isEmpty else { return "error" }
        return viewModel.rows.value[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("COMPONENT: \(component), ROW: \(row)")
        self.updateData()
    }
    
    private func updateData() {
        guard let range = viewModel.getDateRange() else { return }
        
        var right: String?
        
        let componentIndex = 0
        let leftRow = datePicker.selectedRow(inComponent: componentIndex)
        let left = viewModel.rows.value[componentIndex][leftRow]
        
        if range == .monthly {
            let componentIndex = 1
            let rightRow = datePicker.selectedRow(inComponent: componentIndex)
            right = viewModel.rows.value[componentIndex][rightRow]
        }
        
        guard let selectedDateRange = viewModel.updateSelectedRangesData(selectedDataRange: range, left: left, right: right) else { return }
        
        self.delegate?.receivedData(data: selectedDateRange)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct ActivityDatePicker_Previews: PreviewProvider {
    
    static let viewController = ActivityDatePickerViewController(viewModel: viewModel)
    
    static let viewModel = ActivityDatePickerViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
