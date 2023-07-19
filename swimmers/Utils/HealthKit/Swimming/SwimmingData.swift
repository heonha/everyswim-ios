//
//  SwimmingData.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import Foundation

struct SwimmingData: Identifiable {
    let id: UUID
    let duration: TimeInterval
    let startDate: Date
    let endDate: Date
    let distance: Double?
    let activeKcal: Double?
    let restKcal: Double?
    let stroke: Double?
    
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
