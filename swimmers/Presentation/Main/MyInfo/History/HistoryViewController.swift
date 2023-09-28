//
//  HistoryViewController.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/26/23.
//

import UIKit
import SnapKit
import Combine


final class HistoryViewController: UIViewController, CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: HistoryViewModel
    private let tableView = BaseTableView()
    private let emptyCell = UITableViewCell()
    private let loadingIndicator = LoadingIndicator()
    
    // MARK: - Initializer
    init(viewModel: HistoryViewModel = HistoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar(true)
    }
    
}

// MARK: - Helper
extension HistoryViewController {
    
    private func configure() {
        self.navigationItem.title = "모든 수영 기록"
        self.view.backgroundColor = AppUIColor.skyBackground
        loadingIndicator.show()
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SwimRecordMediumCell.self,
                                forCellReuseIdentifier: SwimRecordMediumCell.reuseId)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.hideSeparate()
    }
    
    private func layout() {
        self.view.addSubview(tableView)
        self.view.addSubview(loadingIndicator)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(view)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
    }
    
    private func bind() {
        viewModel.$isLoading.receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.show()
                    self?.tableView.reloadData()
                } else {
                    self?.loadingIndicator.hide()
                }
                
                print("isLoading: \(isLoading)")
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - TableView Protocols
extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.swimRecords.count == 0 {
            return 1
        }
    
        return viewModel.swimRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.swimRecords.isEmpty {
            let cell = EmptySwimSmallCell.withType(.normal)
            
            return cell
        }
        
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: SwimRecordMediumCell.reuseId,
                                 for: indexPath) as? SwimRecordMediumCell else { return emptyCell }
        
        let data = viewModel.swimRecords[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.swimRecords.isEmpty {
            return tableView.frame.height
        }
        return 171 + 12
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }
    
}

#if DEBUG
import SwiftUI

struct HistoryViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            HistoryViewController()
        }
        .ignoresSafeArea()
    }
}
#endif

