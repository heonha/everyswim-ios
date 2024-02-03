//
//  PlaceInformationView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import UIKit
import SnapKit

final class PlaceInformationView: BaseUIView {
    
    private weak var parentVC: BaseViewController?
    
    private lazy var mainHStack = ViewFactory.hStack()
        .addSubviews([labelVStack, distanceLabel])
        .alignment(.top)
    
    private lazy var labelVStack = ViewFactory.vStack()
        .addSubviews([titleLabel, addressLabel, phoneLabel])
        .distribution(.fillProportionally)
    
    private lazy var titleLabel = ViewFactory
        .label("수영장")
        .numberOfLines(0)
        .font(.custom(.sfProBold, size: 18))
        .foregroundColor(AppUIColor.primaryBlue)
    
    private lazy var addressLabel = ViewFactory
        .label("서울시")
        .numberOfLines(0)
        .font(.custom(.sfProLight, size: 15))
    
    private lazy var phoneLabel = ViewFactory
        .label("031-000-0000")
        .foregroundColor(.systemBlue)
        .font(.custom(.sfProMedium, size: 14))
    
    private lazy var distanceLabel = ViewFactory
        .label("􀝢 100m")
        .foregroundColor(.label)
        .font(.custom(.sfProLight, size: 14))
        .textAlignemnt(.right)
    
    private var placeUrl = ""

    // MARK: - Init
    init(parentVC: BaseViewController?) {
        self.parentVC = parentVC
        super.init()
        configure()
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        self.layer.setFigmaShadow()
        self.layer.cornerRadius = 16
        self.isHidden = true
    }
    
    public func setData(data: MapPlace) {
        titleLabel.text = data.placeName
        let roadAddress = data.roadAddressName
        addressLabel.text = !roadAddress.isEmpty ? roadAddress : data.addressName
        distanceLabel.text = "􀝢 \(data.distanceWithUnit())"
        placeUrl = data.placeURL
        phoneLabel.text = data.phone
    }
    
    // MARK: - Observe
    private func observe() {
        observeUrlTap()
    }
    
    private func observeUrlTap() {
        contentView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("TAPPED")
                guard let self = self else {return}
                guard let url = URL(string: placeUrl) else {
                    print("URL IS NIL")
                    return
                }
                let request = URLRequest(url: url)
                let webVC = PlaceWebViewController(request: request)
                self.parentVC?.present(webVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Layout
    private func layout() {
        layoutLabels()
    }

    private func layoutLabels() {
        contentView.addSubview(mainHStack)
        mainHStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(12)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(24)
            make.width.equalTo(80)
        }
    }
    
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct PlaceView_Previews: PreviewProvider {
    
    static let viewController = MapViewController(viewModel: viewModel)
    static let locationManager = DeviceLocationManager.shared
    static let viewModel = PoolViewModel(locationManager: locationManager, regionSearchManager: .init())
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }

}
#endif
