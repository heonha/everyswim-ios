//
//  ActivityViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import UIKit
import SnapKit
import Combine

final class ActivityViewController: BaseViewController {
        
    private let viewModel: ActivityViewModel
    
    private lazy var mainScrollView = ActivityView(viewModel: viewModel, parentVC: self)

    // MARK: - Initializer
    init(viewModel: ActivityViewModel = .init()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.hideNavigationBar(false)
    }

    // MARK: - Configure & Layout
    private func configure() {
        // Navigation Title
        setNaviagationTitle(title: "수영 기록")
    }
    
    private func layout() {
        self.view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Bind (Subscribers)
    private func bind() {
        bindPresentDatePicker()
    }

    private func bindPresentDatePicker() {
        mainScrollView.titleMenu.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                if viewModel.selectedSegment == .total { return }
                let vc = ActivityDatePicker(viewModel: self.viewModel)
                self.present(vc, animated: true)
            }
            .store(in: &cancellables)
    }

}

// MARK: - TableView Delegate
extension ActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? RecordMediumCell else {return}
        let data = cell.getData()
        let detailVC = ActivityDetailViewController(data: data)
        self.push(detailVC, animated: true)
    }
    
}

// MARK: - TableView datasource
extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.presentedData.isEmpty {
            return 1
        } else {
            return viewModel.presentedData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.presentedData.isEmpty {
            let emptyCell = BaseEmptyTableViewCell()
            return emptyCell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordMediumCell.reuseId, 
                                                       for: indexPath) as? RecordMediumCell else { return EmptyRecordCell()
        }
        
        let data = viewModel.presentedData[indexPath.row]
        cell.setData(data)
        return cell
    }
    
}

// MARK: - Previewer
#if DEBUG
import SwiftUI

struct ActivityViewController_Previews: PreviewProvider {
    
    static let viewController = ActivityViewController(viewModel: viewModel)
    static let viewModel = ActivityViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
