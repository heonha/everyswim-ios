//
//  PoolSearchView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/25/23.
//

import Foundation

import UIKit
import SnapKit

final class PoolSearchView: BaseUIView {
    
    private let viewModel: PoolViewModel
    private weak var parentVC: PoolSearchViewController?
    
    // MARK: - Views
    private let tableView = BaseTableView(frame: .zero, style: .plain)
            
    // MARK: StackViews
    private lazy var locationVStack = ViewFactory
        .vStack()
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
    
    // MARK: - Init
    init(viewModel: PoolViewModel, parentVC: PoolSearchViewController?) {
        self.viewModel = viewModel
        self.parentVC = parentVC
        super.init()
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        configureLocationAccessDenyState()
        configureTableView()
    }
    
    func configureLocationAccessDenyState() {
        let manager = DeviceLocationManager.shared
        if !manager.isDidAuthorization {
            self.currentLocationLabel.text = "아래 버튼을 눌러 지역을 선택하세요."
            self.searchLocationLabel.text = "지역 선택"
        }
    }
    
    private func configureTableView() {
        print("CONFIGURE DELEGATES")
        tableView.delegate = parentVC
        tableView.dataSource = parentVC
        tableView.register(PoolMediumCell.self,
                           forCellReuseIdentifier: PoolMediumCell.reuseId)
    }
    
    private func bind() {
        bindCurrentLocation()
        bindCurrentRegion()
        bindSearchPool()
        bindTouchGestures()
        bindIsLoading()
    }
    
    /// [Observe] 지역 변경 감지해서 현재지역 라벨 업데이트.
    private func bindCurrentRegion() {
        viewModel.$currentRegion
            .receive(on: DispatchQueue.main)
            .filter { !$0.name.isEmpty }
            .sink { [weak self] region in
                self?.currentLocationLabel.text = "\(region.name) \(region.district)"
            }
            .store(in: &cancellables)
    }
        
    /// [Observe] 타겟 지역 변겸 감지해서 타지역 검색
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
                parentVC?.present(nc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    /// 로딩중이면 로딩인디케이터 표시
    private func bindIsLoading() {
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                switch isLoading {
                case true:
                    self?.tableView.activityIndicator.show()
                case false:
                    self?.tableView.activityIndicator.hide()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Layout
    private func layout() {
        layoutCurrentLocationView()
        layoutTableView()
    }

    private func layoutCurrentLocationView() {
        contentView.addSubview(locationVStack)
        locationVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(30)
            make.top.equalTo(contentView)
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
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(locationVStack.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }

}

// MARK: Test Stub
extension PoolSearchView {
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

struct PoolSearchView_Previews: PreviewProvider {
    
    static let parentVC = PoolSearchViewController(viewModel: viewModel)
    static let viewModel = PoolViewModel(locationManager: .shared, regionSearchManager: .init())
    static let view = PoolSearchView(viewModel: viewModel, parentVC: parentVC)
    
    static var previews: some View {
        UIViewControllerPreview {
            parentVC
        }
        .ignoresSafeArea()
    }
}
#endif
