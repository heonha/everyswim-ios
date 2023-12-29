//
//  CLLocationCoordinate2D+Ext.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/29/23.
//

#if DEBUG
import Foundation
import CoreLocation

extension CLLocationCoordinate2D: TestableObject {
    
    static var example: CLLocationCoordinate2D = .init(latitude: 37.495368057754774, longitude: 126.88734144230949)

}
#endif
