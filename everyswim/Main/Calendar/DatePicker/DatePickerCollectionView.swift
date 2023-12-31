//
//  DatePickerController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/10/23.
//

import UIKit
import SnapKit

final class DatePickerCollectionView: UICollectionView {
    
    private let viewModel: DatePickerViewModel
    
    init(viewModel: DatePickerViewModel) {
        let layout = FlowLayout.datePicker.get(cellSize: viewModel.getCellSize())
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
