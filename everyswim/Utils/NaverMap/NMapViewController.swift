//
//  MapViewController.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/30/23.
//

import UIKit
import SnapKit
import NMapsMap

final class NMapViewController: BaseViewController {
    
    private let viewModel: NMapViewModel
    
    private lazy var mapView = NMFNaverMapView(frame: view.frame)
    
    init(viewModel: NMapViewModel = .init()) {
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
    
    private func configure() {
        NMFAuthManager.shared().delegate = self
        mapView.showLocationButton = true
        mapView.showScaleBar = false
    }
    
    private func layout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}

extension NMapViewController: NMFAuthManagerDelegate {
    
    func authorized(_ state: NMFAuthState, error: Error?) {
        if let error = error {
            print("AuthError: \(error.localizedDescription)")
            return
        }
        
        print("STATE: \(state)")
    }

}


// MARK: - Preview
#if DEBUG
import SwiftUI

struct MapViewController_Previews: PreviewProvider {
    
    static let viewController = NMapViewController()
    static let viewModel = NMapViewModel()
    
    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif

