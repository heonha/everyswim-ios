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
    
    // MARK: - LifeCycles
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Setup
    
    func actionMaker(index: Int) -> UIAction {
        guard let type = ActivityDataRange(rawValue: index) else {fatalError("타입에러")}
        
        return UIAction {[weak self] action in
            self?.segmentAction(type: type)
        }
    }
    
    private func configure() {
        configureButtons()
        configureSegmentAppearances()
        selectSegment(index: 1)
    }
    
    private func segmentAction(type: ActivityDataRange) {
        self.viewModel.getData(type)
        self.viewModel.resetPickerData()
        self.viewModel.selectedSegment = type
    }
    
    func selectSegment(index: Int) {
        selectedSegmentIndex = index
        let type = ActivityDataRange.init(rawValue: index)!
        viewModel.selectedSegment = type
        segmentAction(type: type)
    }
    
    private func configureButtons() {
        let cases = ActivityDataRange.allCases
        
        for singleCase in cases {
            let action = actionMaker(index: singleCase.rawValue)
            self.insertSegment(action: action, at: singleCase.rawValue, animated: true)
            self.setAction(action, forSegmentAt: singleCase.rawValue)
            setTitle(singleCase.segmentTitle, forSegmentAt: singleCase.rawValue)
        }
    }
    
    private func configureSegmentAppearances() {
        selectedSegmentTintColor = AppUIColor.secondaryBlue
        
        let normalTitleAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.custom(.sfProLight, size: 14),
            .foregroundColor: UIColor.black
        ]
        
        let selectedTitleAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.custom(.sfProBold, size: 14),
            .foregroundColor: UIColor.white
        ]

        setTitleTextAttributes(normalTitleAttributes, for: .normal)
        setTitleTextAttributes(selectedTitleAttributes, for: .selected)
    }

}
