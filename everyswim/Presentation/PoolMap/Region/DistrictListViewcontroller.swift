//
//  DistrictListViewcontroller.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation

import UIKit
import SnapKit

final class DistrictListViewcontroller: BaseViewController {
    
    private let tableView = UITableView()

    private let region: KrRegions
    private let viewModel: PoolMapViewModel

    // MARK: - Init & Lifecycles
    init(region: KrRegions, viewModel: PoolMapViewModel) {
        self.region = region
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    // MARK: - Configures
    private func configure() {
        configureNavigation()
        tableViewConfigure()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "지역 선택"
        self.navigationItem.backButtonDisplayMode = .generic
    }
    
    private func tableViewConfigure() {
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
    
}

// MARK: - TableView
extension DistrictListViewcontroller: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return region.districts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionListCell.reuseId, for: indexPath) as? RegionListCell else { return UITableViewCell() }
        
        let district = region.districts[indexPath.row]
        cell.configure(title: district)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDistrict = region.districts[indexPath.row]
        let selectedRegion = region.name
        let code = viewModel.cityNameToCode(city: selectedRegion)
        let data = SingleRegion(code: code, name: selectedRegion, district: selectedDistrict)
        viewModel.currentRegion = data
        viewModel.customLoationMode = true
        self.dismiss(animated: true)
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct DistrictListViewcontroller_Previews: PreviewProvider {
    
    static let viewController = DistrictListViewcontroller(region: region, viewModel: viewModel)
    static let viewModel = PoolMapViewModel(locationManager: .init(),
                                             regionSearchManager: .init())
    static let region = KrRegions(code: "0", name: "서울시", districts: ["구로구", "강남구", "강서구"])
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
