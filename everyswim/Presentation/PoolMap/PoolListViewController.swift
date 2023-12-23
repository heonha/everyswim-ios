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

final class PoolListViewController: BaseViewController, UseCancellables {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let tableView = UITableView()
    
    private let viewModel: PoolMapViewModel
    
    private lazy var naverMapViewController = PoolMapViewController(viewModel: viewModel)
        
    // MARK: StackViews
    private lazy var locationVStack = ViewFactory.vStack()
        .addSubviews([titleLabel, currentLocationLabel, searchLocationLabel])
        .alignment(.center)
        .distribution(.fillEqually)
        .setEdgeInset(.vertical(8))
        .backgroundColor(.secondarySystemBackground)
        .cornerRadius(8)
    
    // MARK: SubViews
    private let titleLabel = ViewFactory
        .label("위치")
        .font(.custom(.sfProMedium, size: 14))
        .textAlignemnt(.center)
    
    private let currentLocationLabel = ViewFactory
        .label("--시 --구")
        .font(.custom(.sfProMedium, size: 16))
        .textAlignemnt(.center)
    
    private let searchLocationLabel = ViewFactory
        .label("다른지역 찾기")
        .font(.custom(.sfProBold, size: 14))
        .textAlignemnt(.center)
        .backgroundColor(.secondarySystemFill)
        .shadow()
        .cornerRadius(8) as! UILabel

    private let showMapButton = UIImageView()
        .setSymbolImage(systemName: "map", color: .label)
        .contentMode(.scaleAspectFit)
    
    // MARK: - Init
    init(viewModel: PoolMapViewModel) {
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
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    // MARK: - configure
    private func configure() {
        configureTableView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let showMapButton = UIBarButtonItem(customView: showMapButton)
        self.navigationItem.rightBarButtonItem = showMapButton
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PoolInfoMediumCell.self,
                           forCellReuseIdentifier: PoolInfoMediumCell.reuseId)
    }
    
    // MARK: - Layout
    private func layout() {
        layoutCurrentLocationView()
        layoutTableView()
    }
    
    private func dismissGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissAction))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func dismissAction() {
        self.dismiss(animated: true)
    }

    private func layoutCurrentLocationView() {
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
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(locationVStack.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
        showMapButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                naverMapViewController.placeMarker(from: viewModel.places)
                push(naverMapViewController, animated: true)
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
        viewModel.$targetCurrentLocation
            .receive(on: DispatchQueue.main)
            .filter { $0.latitude != CGFloat(0) && $0.longitude != CGFloat(0) }
            .sink { [weak self] coordinator in
                self?.viewModel.getAddressFromCoordinator(coordinator)
            }
            .store(in: &cancellables)
    }
    
    private func bindSearchPool() {
        viewModel.$places
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] _ in
                guard let self = self else { return }
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindTouchGestures() {
        /// `지역 선택하기` 버튼
        searchLocationLabel.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                let vc = RegionListViewController(viewModel: viewModel)
                let nc = RootNavigationViewController(rootViewController: vc)
                present(nc, animated: true)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - TableView Configure
extension PoolListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PoolInfoMediumCell.reuseId, for: indexPath) as? PoolInfoMediumCell else {
            return UITableViewCell()
        }
        
        let location = viewModel.places[indexPath.row]
        cell.configure(data: location as! KakaoPlace)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let coordinator = viewModel.places[indexPath.row].getCoordinator() else { return }
        self.push(naverMapViewController, animated: true)
        self.naverMapViewController.updateCamera(coordinator)
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
    
    static let navigationController = RootNavigationViewController(rootViewController: viewController)
    static let viewController = PoolListViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager()
    static let viewModel = PoolMapViewModel(locationManager: locationManager, regionSearchManager: .init())
    
    static var previews: some View {
        UIViewControllerPreview {
            navigationController
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.targetCurrentLocation = .init(latitude: 35.570137, longitude: 126.977127)
        })
    }
}
#endif
