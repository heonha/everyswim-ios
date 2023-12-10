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

    private let region: Region
    private let viewModel: RegionSearchViewModel
    private let parentViewModel: PoolListViewModel

    // MARK: - Init & Lifecycles
    init(region: Region, viewModel: RegionSearchViewModel, parentViewModel: PoolListViewModel) {
        self.region = region
        self.viewModel = viewModel
        self.parentViewModel = parentViewModel
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
    
    private func bind() {
        
    }
    
    private func cityNameToCode(city: String) -> Int {
        
        let cities = [
            "서울" : 11,
            "부산" : 21,
            "인천" : 22,
            "대구" : 23,
            "광주" : 24,
            "대전" : 25,
            "울산" : 26,
            "경기" : 31,
            "강원" : 32,
            "충북" : 33,
            "충남" : 34,
            "전북" : 35,
            "전남" : 36,
            "경북" : 37,
            "경남" : 38,
            "제주" : 39,
            "세종" : 41
        ]
        
        let cityCode = cities.first { key, value in
            areFirstTwoCharactersEqual(city, key)
        }
        
        guard let cityCode = cityCode else { return 0 }
        
        return cityCode.value
    }
    
    
    func areFirstTwoCharactersEqual(_ str1: String, _ str2: String) -> Bool {
        guard str1.count >= 2 && str2.count >= 2 else {
            return false
        }
        
        return str1.prefix(2) == str2.prefix(2)
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
        let code = cityNameToCode(city: selectedRegion)
        let data = RegionViewModel(code: code, name: selectedRegion, district: selectedDistrict)
        parentViewModel.currentRegion = data
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct DistrictListViewcontroller_Previews: PreviewProvider {
    
    static let viewController = DistrictListViewcontroller(region: region, viewModel: viewModel, parentViewModel: .init(locationManager: .init()))
    static let viewModel = RegionSearchViewModel()
    static let region = Region(code: "0", name: "서울시", districts: ["구로구", "강남구", "강서구"])
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif

