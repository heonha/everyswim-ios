//
//  ActivitySegment.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit
import Combine

final class ActivitySegment: UIView, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ActivityViewModel
    
    // 셀렉터 (일간 - 주간 - 월간)
    private lazy var dailyButton = ViewFactory
        .label("일간")
        .textAlignemnt(.center)
        .cornerRadius(6)
        .tag(0) as! UILabel
    
    private lazy var weeklyButton = ViewFactory
        .label("주간")
        .textAlignemnt(.center)
        .cornerRadius(6)
        .tag(1) as! UILabel
    
    private lazy var monthlyButton = ViewFactory
        .label("월간")
        .textAlignemnt(.center)
        .cornerRadius(6)
        .tag(2) as! UILabel

    private lazy var dateSelecter = ViewFactory.hStack()
        .addSubviews([dailyButton, weeklyButton, monthlyButton])
        .distribution(.fillEqually)
        .alignment(.center)
        .spacing(2)
    
    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        observe()
    }
    
    private func configure() {
        
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
        
        dailyButton.gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.dailyButton.textColor == .blue { return }
                print("데일리")
                viewModel.selectedSegment = 0
            }
            .store(in: &cancellables)
        
        weeklyButton.gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                print("위클리")
                guard let self = self else { return }
                viewModel.selectedSegment = 1
            }
            .store(in: &cancellables)
        
        monthlyButton.gesturePublisher(.tap())
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                print("몬쓸리")
                guard let self = self else { return }
                viewModel.selectedSegment = 2
            }
            .store(in: &cancellables)
        
    }
    
    func getSegment() -> UIStackView {
        return self.dateSelecter
    }
    
}

