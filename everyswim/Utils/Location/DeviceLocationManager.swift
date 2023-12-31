//
//  DeviceLocationManager.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/3/23.
//

import Foundation
import CoreLocation
import Combine

final class DeviceLocationManager: NSObject {
    
    static let shared = DeviceLocationManager()
    
    private var locationManager = CLLocationManager()
    private var requestLocationAuthorizationCallBack: ((CLAuthorizationStatus) -> Void)?
    private var locationSubject = CurrentValueSubject<CLLocationCoordinate2D, Error>(.init())
    var locationPublisher: AnyPublisher<CLLocationCoordinate2D, Error> {
        locationSubject.eraseToAnyPublisher()
    }
    
    var isDidAuthorization: Bool = false
    
    private override init() {
        super.init()
        print("DELEGATE SET")
        locationManager.delegate = self
    }
    
    public func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
}

extension DeviceLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if locationAuthorizedCheck(status: status) {
            self.isDidAuthorization = true
            print("위치 허용 확인.")
            guard let currentLocation = locationManager.location?.coordinate else {return}
            locationSubject.send(currentLocation)
        } else {
            print("위치 허용 되지 않음.")
            self.isDidAuthorization = false
        }
    }
    
    private func locationAuthorizedCheck(status: CLAuthorizationStatus) -> Bool {
        status == .authorizedAlways || status == .authorizedWhenInUse ? true : false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error.localizedDescription)")
    }
    
}
