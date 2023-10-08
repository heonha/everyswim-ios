//
//  PickerModalViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 10/8/23.
//

import UIKit
import SnapKit
import Combine

final class PickerModalViewController: UIViewController, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private var years = [String]()
    private var months = [String]()
    
    private let viewModel: ActivityViewModel
    
    var leftString = "" {
        willSet {
            print("LEFT: \(newValue)")
        }
    }
    var rightString: String? {
        willSet {
            print("RIGHT: \(newValue!)")
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleData()
        configure()
        bind()
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
    
    private func setFirstPickedData() {
        if viewModel.selectedSegment == .weekly {
            let date = Date()
            self.leftString = date.toString(.year)
            self.rightString = date.toString(.monthFull)
        }
    }
    
    private func setTitleData() {
        
        for year in 2020...2023 {
            years.append("\(year)")
        }
        
        for month in 1...12 {
            if month < 10 {
                months.append("0\(month)")
            } else {
                months.append("\(month)")
            }
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
        
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(hstack.snp.bottom).offset(16)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
        }
        
    }

    private func isHideRightPicker(_ value: IsHidden = .hide) {
        rightPicker.isHidden = value.boolType
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        print("DISMISS")
    }
    
    private func bind() {
        applyButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if viewModel.selectedSegment == .weekly, rightString == nil {
                    self.dismiss(animated: true)
                    return
                }
                
                viewModel.setSelectedDate(left: leftString, right: rightString)
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
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
        case .yearly:
            isHideRightPicker(.hide)
        }
    }
    
}
// MARK: - PickerView Protocols
extension PickerModalViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == leftPicker {
            switch viewModel.selectedSegment {
            case .daily:
                self.leftString = viewModel.days[row].toString(.day)
            case .weekly:
                self.leftString = viewModel.days[row].toStringWeekNumber()
            case .monthly:
                self.leftString = years[row]
            case .yearly:
                self.leftString = viewModel.year[row].toString(.year)
            }
        }
        
        if pickerView == rightPicker {
            switch viewModel.selectedSegment {
            case .monthly:
                self.rightString = months[row]
            default:
                print("rightError")
            }
        }
        
    }
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
                return years.count
            case .yearly:
                return viewModel.year.count
            }
        }
        
        if pickerView == rightPicker {
            switch viewModel.selectedSegment {
            case .daily:
                return 0
            case .weekly:
                return 0
            case .monthly:
                return months.count
            case .yearly:
                return 0
            }
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == leftPicker {
            switch viewModel.selectedSegment {
            case .daily:
                return viewModel.days[row].toString(.day)
            case .weekly:
                return "\(viewModel.weeks[row].toStringWeekNumber())주차"
            case .monthly:
                return "\(years[row])년"
            case .yearly:
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
                return "\(months[row])월"
            case .yearly:
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
