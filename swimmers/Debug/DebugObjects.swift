//
//  DebugObjects.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/08.
//

#if DEBUG
import Foundation

class DebugObjects {
    static let rings = [
        ChallangeRing(type: .distance, count: 1680, maxCount: 2000),
        ChallangeRing(type: .lap, count: 45, maxCount: 60),
        ChallangeRing(type: .countPerWeek, count: 2, maxCount: 3)
    ]
}


#endif
