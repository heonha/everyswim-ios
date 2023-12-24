//
//  MapMarker.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/23/23.
//

import Foundation
import CoreLocation

protocol MapPlace {
    var placeName: String { get set }
    var x: String { get set }
    var y: String { get set }
    var distance: String? { get set }
    var addressName: String { get set }
    var roadAddressName: String { get set }
}

extension MapPlace {
    
    func getCoordinator() -> CLLocationCoordinate2D? {
        guard let lat = y.toDouble(), let lon = x.toDouble() else {return nil}
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func distanceWithUnit() -> String {
        guard let distance = distance else {return ""}
        guard let distanceDouble = distance.toDouble() else {return ""}
        
        let distanceString: String = {
            if distanceDouble > 1000 {
                let killometer = distanceDouble / 1000
                return killometer.toRoundupString(maxDigit: 1) + "km"
            } else {
                return distanceDouble.toRoundupString() + "m"
            }
        }()
        return distanceString
    }
    
}
