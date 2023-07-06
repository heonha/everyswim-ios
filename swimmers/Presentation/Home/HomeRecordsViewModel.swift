//
//  HomeViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import Combine
import HealthKit

final class HomeRecordsViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    
    private var kcals: [HealthStatus] = []
    private var stroke: [HealthStatus] = []
    
    @Published var swimRecords: [SwimmingData]
    @Published var kcalPerWeek: Double = 0.0
    @Published var strokePerMonth: Double = 0.0
    
    init(swimRecords: [SwimmingData]? = nil, healthKitManager: HealthKitManager = HealthKitManager()) {
        self.swimRecords = swimRecords ?? []
        hkManager = HealthKitManager()
        Task { await loadHealthCollection() }
    }
    
    func fetchSwimmingData() async {
        let swimmingData = await hkManager?.loadSwimmingDataCollection()
        if let swimmingData = swimmingData {
            DispatchQueue.main.async {
                self.swimRecords = swimmingData
            }
        } else {
            return
        }
    }
        
    func loadHealthCollection() async {
        self.kcals = []
        self.stroke = []
        
        print("DEBUG: 헬스 데이터 가져오기")
        guard let hkManager = hkManager else { return }
        
        print("DEBUG: 인증을 확인합니다")
        
        let isAuthed = await hkManager.requestAuthorization()
        
        if isAuthed {
            hkManager.getHealthData(dataType: .kcal, queryRange: .week) { result in
                if let statCollection = result {
                    print("업데이트 \(statCollection)")
                    self.updateUIFromStatistics(statCollection, type: .kcal, queryRange: .week)
                } else {
                    print("Collection 가져오기실패")
                }
            }
        } else {
            print("DEBUG: Health 일반 데이터 권한이 거부되었습니다.")
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
        statCollection.enumerateStatistics(from: startDate, to: endDate) { statCollection, _ in
            
            switch type {
            case .kcal:
                var count = statCollection.sumQuantity()?.doubleValue(for: .kilocalorie())
                guard let count = count else { return }
                let data = HealthStatus(count: count, date: statCollection.startDate)
                print("Debug: kcal가 완료되었습니다. \(data)")
                self.kcals.append(data)
                
                DispatchQueue.main.async {
                    self.kcalPerWeek = self.kcals.reduce(0) { partialResult, kcal in
                        partialResult + kcal.count
                    }
                }
                print("DEBUG: Kcal per Week\(self.kcalPerWeek)")
            default:
                print("DEBUG: \(#function) 알수없는 오류. default에 도달했습니다.")
                return
            }
        }
    }
    
}