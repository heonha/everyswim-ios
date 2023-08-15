//
//  Lap.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/29.
//

import Foundation
import HealthKit

struct Lap {
    let index: Int
    let dateInterval: DateInterval
    let style: HKSwimmingStrokeStyle?
}
