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
    
    private let viewModel: PoolViewModel
        
    private let tableView = UITableView()
    
    private let myRegionButton = RegionListCell(style: .default, reuseIdentifier: nil)
    
    // MARK: - Init & LifeCycles
    init(viewModel: PoolViewModel) {
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
        configureMyRegionButton()
    }
    
    func configureMyRegionButton() {
        myRegionButton.configure(title: "현재 지역으로 돌아가기")
        myRegionButton.hideArrow()
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
        view.addSubview(myRegionButton)
        view.addSubview(tableView)
        
        myRegionButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(myRegionButton.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view)
        }
    }
    
    private func bind() {
        
        myRegionButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.resetCurrentLocation()
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
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
    static let viewModel = PoolViewModel(locationManager: .init(),
                                             regionSearchManager: .init())
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
