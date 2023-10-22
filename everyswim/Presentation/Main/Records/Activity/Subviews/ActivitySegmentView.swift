//
//  ActivitySegment.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit
import Combine

final class ActivitySegmentView: UIView, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ActivityViewModel
    
    // 셀렉터 (일간 - 주간 - 월간)
    
    private lazy var weeklyButton = ViewFactory
        .label("주간")
        .tag(0) as! UILabel
    
    private lazy var monthlyButton = ViewFactory
        .label("월간")
        .tag(1) as! UILabel
    
    private lazy var yearlyButton = ViewFactory
        .label("연간")
        .tag(2) as! UILabel
    
    private lazy var lifeTimeButton = ViewFactory
        .label("전체")
        .tag(3) as! UILabel
    


    private lazy var dateSelecter = ViewFactory.hStack()
        .addSubviews([weeklyButton, monthlyButton, yearlyButton, lifeTimeButton])
        .distribution(.fillEqually)
        .alignment(.center)
        .spacing(2)
        .cornerRadius(6)
        .backgroundColor(.systemGray6) as! UIStackView
    
    // MARK: - Initializer
    
    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles

    override func layoutSubviews() {
        super.layoutSubviews()
        observe()
        firstGetData()
    }
    
    // MARK: - Setup
    
    private func configure() {
        dateSelecter.subviews
            .forEach { view in
                let view = view as! UILabel
                view.font = .custom(.sfProLight, size: 14)
                view.layer.cornerRadius = 6
                view.layer.masksToBounds = true
                view.textAlignment = .center
            }
    }
    
    private func firstGetData() {
        switch viewModel.selectedSegment {
        case .weekly:
            viewModel.getData(.weekly)
        case .monthly:
            viewModel.getData(.monthly)
        case .yearly:
            viewModel.getData(.yearly)
        case .total:
            viewModel.getData(.total)
        }
    }
    
    private func layout() {
        self.addSubview(dateSelecter)
        dateSelecter.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateSelecter.subviews.forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(dateSelecter)
            }
        }
    }
    
    private func observe() {
                
        weeklyButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                viewModel.selectedSegment = .weekly
                viewModel.getData(.weekly)
            }
            .store(in: &cancellables)
        
        monthlyButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                viewModel.selectedSegment = .monthly
                viewModel.getData(.monthly)
            }
            .store(in: &cancellables)
        
        yearlyButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                viewModel.selectedSegment = .yearly
                viewModel.getData(.yearly)
            }
            .store(in: &cancellables)
        
        lifeTimeButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                viewModel.selectedSegment = .total
                viewModel.getData(.total)
            }
            .store(in: &cancellables)
        
    }
    
    func getSegment() -> UIStackView {
        return self.dateSelecter
    }
    
}
