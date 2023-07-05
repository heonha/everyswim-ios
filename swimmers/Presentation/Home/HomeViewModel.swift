//
//  HomeViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import Combine
import HealthKit

final class HomeViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    
    private var kcals: [HealthStatus] = []
    private var stroke: [HealthStatus] = []
    
    @Published var swimRecords: [HKWorkout] = []
    @Published var kcalPerWeek: Double = 0.0
    @Published var strokePerMonth: Double = 0.0
    
    init() {
        hkManager = HealthKitManager()
    }
    
    func loadSwimmingDataCollection() async {
        print("Swimming Data 가져오기")
        guard let hkManager = hkManager else {
            return
        }
        
        let result = await hkManager.requestAuthorization()
        
        if result {
            let records = await hkManager.readWorkouts()
            
            if let records = records {
                DispatchQueue.main.async {
                    self.swimRecords = records
                    print("Swimming Data를 가져왔습니다. \(records)")
                }
            } else {
                print("Swimmming Data를 가져오기 못했습니다.")
            }
        } else {
            print("권한이 거부되었습니다.")
        }
        
    }
    
    func loadHealthCollection() async {
        
        self.kcals = []
        self.stroke = []
        
        print("DEBUG: 헬스 데이터 가져오기")
        guard let hkManager = hkManager else { return }
        
        print("DEBUG: 인증을 확인합니다")
        
        let isAuthed = await hkManager.requestAuthorization()
        
        switch isAuthed {
        case true:
            hkManager.getHealthData(dataType: .kcal, queryRange: .week) { result in
                if let statCollection = result {
                        print("업데이트 \(statCollection)")
                        self.updateUIFromStatistics(statCollection, type: .kcal, queryRange: .month)
                } else {
                    print("Collection 가져오기실패")
                    return
                }
            }
        case false:
            return
        }
    }
    
    func updateUIFromStatistics(_ statCollection: HKStatisticsCollection,
                                type: HKQueryDataType,
                                queryRange: HKDateType) {
        
        guard let startDate = Calendar.current.date(byAdding: .day,
                                                    value: queryRange.value(),
                                                    to: Date()) else { return }
        let endDate = Date()
        
        print("Debug: \(#function) StatCollection만들기 시작")
        /// 시작 날짜부터 종료 날짜까지의 모든 시간 간격에 대한 통계 개체를 열거합니다.
        statCollection
            .enumerateStatistics(from: startDate, to: endDate) { statCollection, _ in
                
                print("Debug: kcal이 완료되었습니다.")
                var count: Double?
                
                
                switch type {
                case .kcal:
                    count = statCollection.sumQuantity()?.doubleValue(for: .kilocalorie())
                    guard let count = count else {return }
                    let data = HealthStatus(count: count, date: statCollection.startDate)
                    self.kcals.append(data)

                case .stroke:
                    count = statCollection.sumQuantity()?.doubleValue(for: .count())
                    guard let count = count else {return }
                    let data = HealthStatus(count: count, date: statCollection.startDate)
                    self.stroke.append(data)
                default:
                    print("DEBUG: \(#function) 알수없는 오류. default에 도달했습니다.")
                    return
                }
                
                print("DEBUG: \(#function) 결과를 확인합니다. ")
                print("DEBUG: Kcal: \(self.kcals)")
                print("DEBUG: Stroke: \(self.stroke)")

            }
        
        switch type {
        case .kcal:
            DispatchQueue.main.async {
                self.kcalPerWeek = self.kcals.reduce(0) { partialResult, kcal in
                    partialResult + kcal.count
                }
                print("DEBUG: Kcal per Week\(self.kcalPerWeek)")

            }
        case .stroke:
            DispatchQueue.main.async {
                self.strokePerMonth = self.stroke.reduce(0) { partialResult, stroke in
                    partialResult + stroke.count
                }
                print("DEBUG: Stroke per Month\(self.strokePerMonth)")
            }
        default:
            return
        }
        
    }
    
}
