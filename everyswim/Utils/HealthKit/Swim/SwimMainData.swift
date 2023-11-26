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
        return duration.toRelativeTime(.hourMinute, unitStyle: .full)
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
    
    /// distance + m
    var distanceString: String {
        var distance = unwrappedDistance.toRoundupString()
        distance += " m"
        return distance
    }
    
    var totalKcalString: String {
        return totalKcal.toRoundupString() + " kcal"
    }
    
    func getWeekDay() -> String {
        return startDate.toString(.weekDay)
    }
    
    func getDayDotMonth() -> String {
        return startDate.toString(.dayDotMonth)
    }
    
    func getSimpleRecords() -> (duration: String, distance: String, lap: String) {
        
        let duration = self.duration.toRelativeTime(.hourMinute)
        let distance = self.unwrappedDistance.toRoundupString()
        let lap = self.laps.count.description
        
        return (duration: duration, distance: distance, lap: "\(lap)")
    }
    
    static func PlaceholderSimpleRecords() -> (duration: String, distance: String, lap: String){
        let duration = "1시간 10분"
        let distance = "600"
        let lap = 20.description
        
        return (duration: duration, distance: distance, lap: lap)
    }
    
}
