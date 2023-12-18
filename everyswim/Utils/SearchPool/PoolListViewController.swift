//
//  RegionListViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit
import Combine
import CoreLocation

final class PoolListViewController: BaseViewController, CombineCancellable {
    var cancellables: Set<AnyCancellable> = .init()
    
    private let titleLabel = ViewFactory.label("현재 위치")
        .font(.custom(.sfProMedium, size: 14))
        .textAlignemnt(.center)
    
    private let currentLocationLabel = ViewFactory.label("--시 --구")
        .font(.custom(.sfProMedium, size: 16))
        .textAlignemnt(.center)
    
    private let searchLocationLabel = ViewFactory.label("다른지역 찾기")
        .font(.custom(.sfProBold, size: 14))
        .textAlignemnt(.center)
        .backgroundColor(.secondarySystemFill)
        .shadow()
        .cornerRadius(8)
    
    private lazy var locationVStack = ViewFactory.vStack()
        .addSubviews([titleLabel, currentLocationLabel, searchLocationLabel])
        .alignment(.center)
        .distribution(.fillEqually)
        .setEdgeInset(.vertical(8))
        .backgroundColor(.secondarySystemBackground)
        .cornerRadius(8)

    private let showMapLabel = ViewFactory.label("􀙊 지도에서 찾기")
        .font(.custom(.sfProBold, size: 16))
        .textAlignemnt(.center)
        .backgroundColor(AppUIColor.skyBackground)
        .shadow()
        .cornerRadius(8)
    
    private let dismissButton = ViewFactory.label("나가기")
        .font(.custom(.sfProBold, size: 16))
        .textAlignemnt(.center)
        .backgroundColor(AppUIColor.skyBackground)
        .shadow()
        .cornerRadius(8)
    
    private let tableView = UITableView()
    
    private let viewModel: PoolListViewModel
    
    
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
    
    // MARK: - Configurations
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PoolMediumCell.self, 
                           forCellReuseIdentifier: PoolMediumCell.reuseId)
    }
    
    // MARK: - Layout
    private func layout() {
        
        view.addSubview(locationVStack)
        
        locationVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        currentLocationLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        searchLocationLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(locationVStack.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        view.addSubview(showMapLabel)
        showMapLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(130)
            make.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(80)
            make.leading.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - Bind
    private func bind() {
        bindCurrentLocation()
        bindCurrentRegion()
        bindPushNaverMapView()
        bindSearchPool()
        bindTouchGestures()
    }
    
    private func bindPushNaverMapView() {
        showMapLabel.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                let locationManager = DeviceLocationManager()
                let viewModel = MapViewModel(locationManager: locationManager)
                let naverMapView = MapViewController(viewModel: viewModel)
                push(naverMapView, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindCurrentRegion() {
        viewModel.$currentRegion
            .receive(on: DispatchQueue.main)
            .filter { !$0.name.isEmpty }
            .sink { [weak self] region in
                self?.currentLocationLabel.text = "\(region.name) \(region.district)"
            }
            .store(in: &cancellables)
    }
        
    private func bindCurrentLocation() {
        viewModel.$currentLoction
            .receive(on: DispatchQueue.main)
            .filter { $0.latitude != CGFloat(0) && $0.longitude != CGFloat(0) }
            .sink { [weak self] coordinator in
                self?.viewModel.getAddressFromCoordinator(coordinator)
            }
            .store(in: &cancellables)
    }
    
    private func bindSearchPool() {
        viewModel.$pools
            .receive(on: DispatchQueue.main)
            .filter{ !$0.isEmpty }
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindTouchGestures() {
        searchLocationLabel.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                let vc = RegionListViewController(viewModel: self.viewModel)
                self.push(vc, animated: true)
            }
            .store(in: &cancellables)
        
        dismissButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
}



// MARK: - TableView Configure
extension PoolListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PoolMediumCell.reuseId, for: indexPath) as? PoolMediumCell else {
            return UITableViewCell()
        }
        
        let location = viewModel.pools[indexPath.row]
        cell.configure(data: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

// MARK: - Test Stub
extension PoolListViewController {
    
    #if DEBUG
    func setCurrentLocation(_ location: String) {
        DispatchQueue.main.async {
            self.currentLocationLabel.text = location
        }
    }
    #endif
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct SearchPoolViewController_Previews: PreviewProvider {
    
    static let viewController = PoolListViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager()
    static let viewModel = PoolListViewModel(locationManager: locationManager, regionSearchManager: .init())
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.currentLoction = .init(latitude: 35.570137, longitude: 126.977127)
        })
    }
}
#endif
