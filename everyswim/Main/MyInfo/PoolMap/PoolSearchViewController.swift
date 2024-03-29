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

final class PoolSearchViewController: BaseViewController, ObservableMessage {

    private let showMapButton = UIImageView()
        .setSymbolImage(systemName: "map", color: .label)
        .contentMode(.scaleAspectFit)
    
    private lazy var mainView = PoolSearchView(viewModel: viewModel, parentVC: self)
    
    private let viewModel: PoolViewModel
    
    lazy var naverMapViewController = MapViewController(viewModel: viewModel)
    
    // MARK: - Init
    init(viewModel: PoolViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.configureLocationAccessDenyState()
    }
    
    // MARK: - Configure
    private func configure() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let showMapButton = UIBarButtonItem(customView: showMapButton)
        self.navigationItem.rightBarButtonItem = showMapButton
    }
    
    // MARK: - Layout
    private func layout() {
        layoutMainView()
    }

    private func layoutMainView() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Bind
    private func bind() {
        bindMessage()
        bindPushNaverMapView()
    }
    
    /// 알림창 State Observe 및 띄우기
    func bindMessage() {
        viewModel.isPresentMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messageString in
                guard let self = self else {return}
                presentMessage(title: messageString)
            }
            .store(in: &cancellables)
    }
    
    /// [제스쳐] 맵 버튼 누르면  맵 뷰 열기.
    private func bindPushNaverMapView() {
        showMapButton.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.naverMapViewController.placeMarker(from: viewModel.places.value)
                self.push(naverMapViewController, animated: true)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - TableView Configure
extension PoolSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !viewModel.places.value.isEmpty else { return 1 }
        
        return viewModel.places.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let places = viewModel.places.value
        
        guard !places.isEmpty else {
            return BaseEmptyTableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PoolMediumCell.reuseId, for: indexPath) as? PoolMediumCell else {
            return UITableViewCell()
        }
        
        let location = places[indexPath.row]
        cell.configure(data: location as! KakaoPlace)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let places = viewModel.places.value
        guard !places.isEmpty else { return tableView.bounds.height }
        return 65
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let places = viewModel.places.value
        let place = places[indexPath.row]
        guard let coordinator = place.getCoordinator() else { return }
        presentMapAndMoveToMarker(target: place, moveTo: coordinator)
    }
    
    /// 맵 뷰를 열고 선택한 마커로 카메라를 이동합니다.
    private func presentMapAndMoveToMarker(target place: MapPlace, moveTo coordinator: CLLocationCoordinate2D) {
        self.push(naverMapViewController, animated: true)
        self.naverMapViewController.updateCamera(coordinator)
        self.naverMapViewController.selectMarker(target: place)
    }
    
}

// MARK: - Test Stub
extension PoolSearchViewController {

}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct SearchPoolViewController_Previews: PreviewProvider {
    
    static let navigationController = RootNavigationViewController(rootViewController: viewController)
    static let viewController = PoolSearchViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager.shared
    static let viewModel = PoolViewModel(locationManager: locationManager, regionSearchManager: .init())
    
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
