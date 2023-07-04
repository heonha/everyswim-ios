//
//  HKCustomError.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/04.
//

import Foundation

enum HealthKitError: Error {
    case unknown
    case healthStoreIsNil
    case hkObjectTypeError
}
