//
//  WorkoutEvent.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/23.
//

import Foundation
import HealthKit

struct WorkoutEvent {
    let id = UUID()
    let type: HKWorkoutEventType
    let start: String
    let end: String
    let duration: TimeInterval
    let metadata: [String: Any]?
    var style: String {
        guard let data = metadata else { return "" }
        guard let value = data["HKSwimmingStrokeStyle"] as? Int else { return ""}
        return HKSwimmingStrokeStyle(rawValue: value)!.name
    }
    
}
