//
//  SwimMainData.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/06.
//

import Foundation
import HealthKit

struct SwimMainData: Identifiable {
    let id: UUID
    let duration: TimeInterval
    let startDate: Date
    let endDate: Date
    let detail: SwimStatisticsData?
    let laps: [Lap]
    
    /// HH시간 mm분 ss초
    var durationString: String {
        return HKCalculator.duration(duration)
    }
    
    var unwrappedDistance: Double {
        if let distance = detail?.distance {
            return distance
        } else {
            return 0
        }
    }
    
    /// 시작일 기준 데이터
    var date: String {
        HKCalculator.toRelativeDate(from: startDate)
    }
    
    /// HH:mm ~ HH:mm
    var durationTime: String {
        HKCalculator.timeHandler(from: startDate, to: endDate)
    }
    
    /// ActiveKcal + RestKcal
    var totalKcal: Double {
        let active = detail?.activeKcal ?? 0
        let rest = detail?.restKcal ?? 0
        
        let totalKcal = active + rest
        
        return totalKcal
    }
    
}
