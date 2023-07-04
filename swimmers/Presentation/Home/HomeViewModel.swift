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
    
    @Published var kcals: [Kcal] = []
    @Published var stroke: [Kcal] = []
    
    @Published var swimRecords: [HKWorkout] = []
    @Published var kcalPerWeek: Double = 0.0
    @Published var strokePerMonth: Double = 0.0
    
    init() {
        hkManager = HealthKitManager()
    }
    
    func getSwimmingRecords() async {
        print("Swimming Data 가져오기")
        guard let hkManager = hkManager else {
            return
        }
        
        let result = await hkManager.requestPermission()
        
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
    
    func loadStats() {
        
        print("DEBUG: 헬스 데이터 가져오기")
        guard let hkManager = hkManager else { return }
        
        print("DEBUG: 인증을 확인합니다")
        hkManager.requestAuthorization { isAuthed in
            switch isAuthed {
            case true:
                hkManager.getHealthData(dataType: .kcal, queryRange: .week) { [unowned self] statCollection in
                    print("DEBUG: 전달받은 건강 데이터 \(statCollection)")
                    if let statCollection = statCollection {
                        DispatchQueue.main.async {
                            print("업데이트 \(statCollection)")
                            self.updateUIFromStatistics(statCollection, type: .kcal, queryRange: .month)
                        }
                    }
                }
                hkManager.getHealthData(dataType: .stroke, queryRange: .month) { [unowned self] statCollection in
                    if let statCollection = statCollection {
                        DispatchQueue.main.async {
                            print("업데이트 \(statCollection)")
                            self.updateUIFromStatistics(statCollection, type: .stroke, queryRange: .month)
                        }
                    }
                }
                
            case false:
                print("권한없음")
                return
            default:
                return
            }
        }
        //        if hkManager.isAuth {
        //            print("DEBUG: 인증확인 \(hkManager.isAuth)")
        
        //        }
    }
    
    func updateUIFromStatistics(_ statCollection: HKStatisticsCollection,
                                type: HKQueryDataType,
                                queryRange: HKDateType) {
        
        guard let startDate = Calendar.current.date(byAdding: .day,
                                                    value: queryRange.value(),
                                                    to: Date()) else { return }
        let endDate = Date()
        
        /// 시작 날짜부터 종료 날짜까지의 모든 시간 간격에 대한 통계 개체를 열거합니다.
        statCollection
            .enumerateStatistics(from: startDate, to: endDate) { statCollection, _ in
                var count: Double?
                switch type {
                case .kcal:
                    count = statCollection.sumQuantity()?.doubleValue(for: .kilocalorie())
                case .stroke:
                    count = statCollection.sumQuantity()?.doubleValue(for: .count())
                default:
                    return
                }
                guard let count = count else {return }
                
                let data = Kcal(count: count, date: statCollection.startDate)
                
                switch type {
                case .kcal:
                    self.kcals.append(data)
                case .stroke:
                    self.stroke.append(data)
                default:
                    return
                }
            }
        
        switch type {
        case .kcal:
            kcalPerWeek = kcals.reduce(0) { partialResult, kcal in
                partialResult + kcal.count
            }
        case .stroke:
            strokePerMonth = stroke.reduce(0) { partialResult, stroke in
                partialResult + stroke.count
            }
        default:
            return
        }
        
    }
    
}
