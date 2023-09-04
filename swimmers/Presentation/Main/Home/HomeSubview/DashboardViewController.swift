//
//  DashboardViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 8/27/23.
//

import UIKit
import SnapKit
import Combine

final class DashboardViewController: UIViewController {
    
    private let viewModel: HomeRecordsViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var headerView = HomeHeaderView(viewModel: viewModel)
    
    private let eventTitle = ViewFactory.label("최근 기록")
        .font(.custom(.sfProLight, size: 15))
        .foregroundColor(.gray)
    
    private lazy var recentRecordView: UIStackView = {
        let vstack = ViewFactory.vStack(subviews: [eventTitle])
        return vstack
    }()
    
    init(viewModel: HomeRecordsViewModel? = nil) {
        self.viewModel = viewModel ?? HomeRecordsViewModel(healthKitManager: HealthKitManager())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayouts()
        bindSubviews()
    }
    
}

extension DashboardViewController {
    
    private func bindSubviews() {
        viewModel.$lastWorkout
            .receive(on: RunLoop.main)
            .sink {[unowned self] data in
                if let data = data {
                    if recentRecordView.arrangedSubviews.count == 2 {
                        print("recentRecordView의 count: \(recentRecordView.arrangedSubviews.count)")
                        let last = recentRecordView.arrangedSubviews.last!
                        recentRecordView.removeArrangedSubview(last)
                    }
                    let view = EventListUICell(data: data, showDate: true)
                    recentRecordView.addArrangedSubview(view)
                }
            }
        .store(in: &subscriptions)
    }
    
    private func setupLayouts() {
        view.addSubview(headerView)
        view.addSubview(recentRecordView)

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        recentRecordView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

    }
    
}

#if DEBUG
import SwiftUI

struct DashboardViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview(vc: DashboardViewController())
    }
}
#endif
