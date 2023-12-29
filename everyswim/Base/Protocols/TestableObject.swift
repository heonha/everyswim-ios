//
//  TestLocationObject.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/23/23.
//

#if DEBUG
import Foundation
import CoreLocation

protocol TestableObject {
    associatedtype Example
    
    static var examples: Example { get }

}

#endif
