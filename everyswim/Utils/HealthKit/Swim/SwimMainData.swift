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

extension SwimMainData: DefaultModelProtocol {

    static var `default`: SwimMainData = SwimMainData.init(id: .init(), duration: 0, startDate: .init(), endDate: .init(), detail: nil, laps: [])
    
}

#if DEBUG
extension SwimMainData: TestableObject {
    
    static var examples: [SwimMainData] = {
          
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm"

           let calendar = Calendar.current

           var swimmingData: [SwimMainData] = []

           let months = Array(1...12)

           for year in Array(2020...2024) {
               for month in months {
                   // Calculate the first day of the month
                   var dateComponents = DateComponents()
                   dateComponents.year = year
                   dateComponents.month = month
                   dateComponents.day = 1
                   guard let firstDayOfMonth = calendar.date(from: dateComponents) else {
                       continue
                   }
                   
                   // Calculate the last day of the month
                   guard let lastDayOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfMonth) else {
                       continue
                   }
                   
                   let daysInMonth = calendar.component(.day, from: lastDayOfMonth)
                   let numDataInMonth = Int.random(in: 1...9) // 한 월에 생성할 데이터 개수 (1에서 9까지 랜덤)
                   
                   for _ in 1...numDataInMonth {
                       let day = Int.random(in: 1...daysInMonth) // 월 내 랜덤한 날짜 선택
                       let hour1 = Int.random(in: 0...23)
                       let minute1 = Int.random(in: 0...59)
                       let hour2 = hour1 + (Int.random(in: 0...1) == 0 ? 0 : 1) // 하루에 1개 또는 2개의 데이터 생성
                       let minute2 = Int.random(in: 0...59)
                       
                       // 시작 시간과 종료 시간 생성
                       let startDateStr = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))-\(String(format: "%02d", hour1)):\(String(format: "%02d", minute1))"
                       let endDateStr = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))-\(String(format: "%02d", hour2)):\(String(format: "%02d", minute2))"
                       
                       // 랩 데이터 생성 (1개에서 5개의 랩 데이터 랜덤 생성)
                       var laps: [Lap] = []
                       let numLaps = Int.random(in: 1...20)
                       for lapIndex in 1...numLaps {
                           let lapStartDate = startDateStr.toDateWithTime()!.addingTimeInterval(Double(lapIndex) * Double.random(in: 15.0...120.0))
                           let lapEndDate = lapStartDate.addingTimeInterval(Double.random(in: 15.0...120.0))
                           let lapStyle: HKSwimmingStrokeStyle? = Int.random(in: 0...1) == 0 ? .freestyle : .breaststroke // 랜덤한 수영 스타일
                           
                           let lap = Lap(index: lapIndex, dateInterval: DateInterval(start: lapStartDate, end: lapEndDate), style: lapStyle)
                           laps.append(lap)
                       }
                       
                       let swimData = SwimMainData(id: UUID(),
                                                   duration: Double.random(in: 1000...10000), // 랜덤한 수영 시간 생성
                                                   startDate: startDateStr.toDateWithTime()!,
                                                   endDate: endDateStr.toDateWithTime() ?? Date(),
                                                   detail: SwimStatisticsData(distance: Double.random(in: 500...1500), // 랜덤한 수영 거리 생성
                                                                              stroke: Double.random(in: 200...600), // 랜덤한 스트로크 수 생성
                                                                              activeKcal: Double.random(in: 100...500), // 랜덤한 활동 열량 생성
                                                                              restKcal: Double.random(in: 50...200)), // 랜덤한 휴식 열량 생성
                                                   laps: laps)
                       swimmingData.append(swimData)
                   }
               }
           }
           return swimmingData
       }()
}
#endif
