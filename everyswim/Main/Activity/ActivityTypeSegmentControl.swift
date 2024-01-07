//
//  ActivityTypeSegmentControl.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityTypeSegmentControl: UISegmentedControl {
        
    private let viewModel: ActivityViewModel
    
    // MARK: - Initializer
    
    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    private func configure() {
        configureButtons()
        configureSegmentAppearances()
        self.selectedSegmentIndex = 1
    }

    private func configureButtons() {
        let cases = ActivityDataRange.allCases
        
        for singleCase in cases {
            let type = ActivityDataRange(rawValue: singleCase.rawValue)
            let action = UIAction { _ in
            }
            self.insertSegment(action: action, at: singleCase.rawValue, animated: true)
            self.setAction(action, forSegmentAt: singleCase.rawValue)
            setTitle(singleCase.segmentTitle, forSegmentAt: singleCase.rawValue)
        }
    }
    
    private func configureSegmentAppearances() {
        selectedSegmentTintColor = AppUIColor.secondaryBlue
        
        let normalTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.custom(.sfProLight, size: 14),
            .foregroundColor: UIColor.black
        ]
        
        let selectedTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.custom(.sfProBold, size: 14),
            .foregroundColor: UIColor.white
        ]

        setTitleTextAttributes(normalTitleAttributes, for: .normal)
        setTitleTextAttributes(selectedTitleAttributes, for: .selected)
    }

}
