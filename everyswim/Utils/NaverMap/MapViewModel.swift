//
//  MapViewModel.swift
//  everyswim
//
//  Created by HeonJin Ha on 11/30/23.
//

import Foundation
import Combine
import CoreLocation

final class MapViewModel: CombineCancellable {
    
    var cancellables: Set<AnyCancellable> = .init()
    private let locationManager: DeviceLocationManager
            
    private let networkService: NetworkService
    
    @Published var searchText: String = ""
    @Published var poolList: [String] = []
    @Published var currentLoction: CLLocationCoordinate2D
    
    init(networkService: NetworkService = .shared, locationManager: DeviceLocationManager) {
        self.currentLoction = .init(latitude: 0, longitude: 0)
        self.networkService = networkService
        self.locationManager = locationManager
        self.getCurrentLocation()
        self.observeCurrentLocation()
    }

}

extension MapViewModel {
    
    func getCurrentLocation() {
        locationManager.requestLocationAuthorization()
    }
    
    func observeCurrentLocation() {
        locationManager.locationPublisher
            .receive(on: DispatchQueue.main)
            .filter { !$0.latitude.isZero }
            .sink(receiveCompletion: { complteion in
                switch complteion {
                case .finished:
                    return
                case .failure(let error):
                    print("위치 받아오기 에러: \(error)")
                }
            }, receiveValue: { [weak self] location in
                print("위치 업데이트 \(location)")
                self?.currentLoction = location
            })
            .store(in: &cancellables)
    }
    
}
