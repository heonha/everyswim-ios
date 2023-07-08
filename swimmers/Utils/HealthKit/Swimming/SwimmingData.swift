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
    
    func getDuration() -> String {
        return HKCalculator.duration(duration)
    }
    
    func getDistance() -> String {
        if let distance = distance {
            return distance.toStringWithoutDecimal()
        } else {
            return "-"
        }
       
    }
    
    func getWorkoutTime() -> String {
        HKCalculator.dateHandeler(from: startDate, to: endDate)
    }
    
    func getTotalKcal() -> String {
        let active = activeKcal ?? 0
        let rest = restKcal ?? 0
        
        let totalKcal = active + rest
        
        return totalKcal.toStringWithoutDecimal()
    }
}

struct SwimCellData: Identifiable {
    let id = UUID()
    let title: String
    let distance: String
    let pace: String
    let duration: String
}
