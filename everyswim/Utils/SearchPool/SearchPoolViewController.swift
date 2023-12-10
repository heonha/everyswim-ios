//
//  SearchPoolViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import UIKit
import SnapKit
import Combine

final class SearchPoolViewController: BaseViewController, CombineCancellable {
    var cancellables: Set<AnyCancellable> = .init()
    
    private let titleLabel = ViewFactory.label("현재 위치")
        .font(.custom(.sfProMedium, size: 14))
        .textAlignemnt(.center)
    
    private let currentLocationLabel = ViewFactory.label("서울시")
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
    
    private let tableView = UITableView()
    
    private let viewModel: MapViewModel
    
    
    // MARK: - Init & LifeCycles
    init(viewModel: MapViewModel) {
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
        
        view.addSubview(showMapLabel)
        showMapLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(130)
            make.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - Bind
    private func bind() {
        bindCurrentLocation()
        bindCurrentRegion()
        bindPushNaverMapView()
    }
    
    private func bindPushNaverMapView() {
        showMapLabel.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                let naverMapView = MapViewController(viewModel: viewModel)
                push(naverMapView, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindCurrentRegion() {
        viewModel.$currentRegion
            .receive(on: DispatchQueue.main)
            .sink { regionString in
                self.currentLocationLabel.text = regionString
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
    
    #if DEBUG
    func setCurrentLocation(_ location: String) {
        DispatchQueue.main.async {
            self.currentLocationLabel.text = location
        }
    }
    
    #endif
    
    
}
// MARK: - TableView Configure
extension SearchPoolViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PoolMediumCell.reuseId, for: indexPath) as? PoolMediumCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct SearchPoolViewController_Previews: PreviewProvider {
    
    static let viewController = SearchPoolViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager()
    static let viewModel = MapViewModel(locationManager: locationManager)
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            viewController.setCurrentLocation("서울특별시 구로구")
        })
    }
}
#endif

