//
//  PickerModalViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/8/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityDatePickerViewController: BaseDatePickerViewcontroller {
    
    private let viewModel: ActivityDatePickerViewModel
    
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
    }
    
    private func configureModal() {
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    func setDateRange(_ range: ActivityDataRange) {
        viewModel.getPickerComponents(range)
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
