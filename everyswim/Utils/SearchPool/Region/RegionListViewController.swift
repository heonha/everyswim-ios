//
//  RegionListViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import UIKit
import SnapKit
import Combine

final class RegionListViewController: BaseViewController {
    
    private let viewModel: PoolListViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    
    // MARK: - Init & LifeCycles
    init(viewModel: PoolListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    // MARK: - Configures
    private func configure() {
        configureNavigation()
        configureTableView()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "지역 선택"
        self.navigationItem.backButtonDisplayMode = .generic
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RegionListCell.self, forCellReuseIdentifier: RegionListCell.reuseId)
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func bind() {
        viewModel.regions
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

extension RegionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.regions.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionListCell.reuseId, for: indexPath) as? RegionListCell else { return UITableViewCell() }
        
        let region = viewModel.regions.value[indexPath.row]
        cell.configure(title: region.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = viewModel.regions.value[indexPath.row]
        let vc = DistrictListViewcontroller(region: region, viewModel: viewModel)
        self.push(vc, animated: true)
    }
    
}


// MARK: - Preview
#if DEBUG
import SwiftUI

struct RegionListViewController_Previews: PreviewProvider {
    
    static let viewController = RegionListViewController(viewModel: viewModel)
    static let viewModel = PoolListViewModel(locationManager: .init(),
                                             regionSearchManager: .init())
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif

