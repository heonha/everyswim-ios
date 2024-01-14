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
    
    init(viewModel: ActivityDatePickerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
