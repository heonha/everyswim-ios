//
//  SwimSummaryViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/30/23.
//

import Foundation

struct SwimSummaryViewModel {
    
    let poolName: String = ""
    let count: Int
    let distance: String
    let distanceUnit: String
    let averagePace: String
    let time: String
    let lap: String
    
}

extension SwimSummaryViewModel: TestableObject {
    static let examples: [SwimSummaryViewModel] = [
        SwimSummaryViewModel(count: 3, distance: "650", distanceUnit: "M", averagePace: "3'22''", time: "30:00", lap: "10")
    ]
}
