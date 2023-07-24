//
//  SwimmingData.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import Foundation
import HealthKit

struct SwimmingData: Identifiable {
    let id: UUID
    let duration: TimeInterval
    let startDate: Date
    let endDate: Date
    let distance: Double?
    let activeKcal: Double?
    let restKcal: Double?
    let stroke: Double?
    let events: [WorkoutEvent]
    
    /// HH시간 mm분 ss초
    var durationString: String {
        return HKCalculator.duration(duration)
    }
    
    var unwrappedDistance: Double {
        if let distance = distance {
            return distance
        } else {
            return 0
        }
    }
    
    var date: String {
        HKCalculator.dateHandeler(from: startDate)
    }
    
    /// HH:mm ~ HH:mm
    var durationTime: String {
        HKCalculator.timeHandler(from: startDate, to: endDate)
    }
    
    var totalKcal: Double {
        let active = activeKcal ?? 0
        let rest = restKcal ?? 0
        
        let totalKcal = active + rest
        
        return totalKcal
    }
}

struct SwimCellData: Identifiable {
    let id = UUID()
    let title: String
    let distance: String
    let pace: String
    let duration: String
}
