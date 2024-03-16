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
        let layout = FlowLayout.datePicker.get(cellSize: viewModel.getSizeForDayCell())
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 16
        backgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundView.backgroundColor = .init(hex: "2B303C")
        self.backgroundView = backgroundView

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

#if DEBUG
import SwiftUI

struct DatePickerCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DatePickerController(viewModel: DatePickerViewModel())
        }
        .ignoresSafeArea()
    }
}
#endif
