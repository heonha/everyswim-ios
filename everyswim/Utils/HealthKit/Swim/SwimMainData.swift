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
    
    func getSimpleRecords() -> SimpleRecord {
        
        let duration = self.duration.toRelativeTime(.hourMinute)
        let distance = self.unwrappedDistance.toRoundupString()
        let lap = self.laps.count.description
        
        return SimpleRecord(duration: duration, distance: distance, lap: "\(lap)")
    }
    
    static func placeholderSimpleRecords() -> SimpleRecord {
        let duration = "1시간 10분"
        let distance = "600"
        let lap = 20.description
        
        return SimpleRecord(duration: duration, distance: distance, lap: lap)
    }
    
    struct SimpleRecord {
        let duration: String
        let distance: String
        let lap: String
    }
    
}



#if DEBUG
extension SwimMainData: TestableObject {
    
    static let examples: [SwimMainData] = SwimMainData.generateSwimmingData()

    static private func generateDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        let dateString = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))-\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
        return dateString.toDateWithTime()
    }

    static private func generateLaps(startDate: Date) -> [Lap] {
        var laps: [Lap] = []
        let numLaps = Int.random(in: 1...20)
        for lapIndex in 1...numLaps {
            let lapStartDate = startDate.addingTimeInterval(Double(lapIndex) * Double.random(in: 15.0...120.0))
            let lapEndDate = lapStartDate.addingTimeInterval(Double.random(in: 15.0...120.0))
            let lapStyle: HKSwimmingStrokeStyle? = Int.random(in: 0...1) == 0 ? .freestyle : .breaststroke

            let lap = Lap(index: lapIndex, dateInterval: DateInterval(start: lapStartDate, end: lapEndDate), style: lapStyle)
            laps.append(lap)
        }
        return laps
    }

    static private func generateSwimData(year: Int, month: Int, day: Int) -> SwimMainData {
        let hour1 = Int.random(in: 0...23)
        let minute1 = Int.random(in: 0...59)
        let hour2 = hour1 + (Int.random(in: 0...1) == 0 ? 0 : 1)
        let minute2 = Int.random(in: 0...59)

        guard let startDate = generateDate(year: year, month: month, day: day, hour: hour1, minute: minute1),
              let endDate = generateDate(year: year, month: month, day: day, hour: hour2, minute: minute2) else {
            fatalError("Invalid date generated")
        }

        let laps = generateLaps(startDate: startDate)

        return SwimMainData(id: UUID(),
                            duration: Double.random(in: 1000...10000),
                            startDate: startDate,
                            endDate: endDate,
                            detail: SwimStatisticsData(distance: Double.random(in: 500...1500),
                                                       stroke: Double.random(in: 200...600),
                                                       activeKcal: Double.random(in: 100...500),
                                                       restKcal: Double.random(in: 50...200)),
                            laps: laps)
    }

    static func generateSwimmingData() -> [SwimMainData] {
        var swimmingData: [SwimMainData] = []
        let calendar = Calendar.current

        for year in 2020...2023 {
            for month in 1...12 {
                guard let firstDayOfMonth = generateDate(year: year, month: month, day: 1, hour: 0, minute: 0),
                      let lastDayOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfMonth) else {
                    continue
                }

                let daysInMonth = calendar.component(.day, from: lastDayOfMonth)
                let numDataInMonth = Int.random(in: 1...9)

                for _ in 1...numDataInMonth {
                    let day = Int.random(in: 1...daysInMonth)
                    let swimData = generateSwimData(year: year, month: month, day: day)
                    swimmingData.append(swimData)
                }
            }
        }
        return swimmingData
    }
}
#endif
