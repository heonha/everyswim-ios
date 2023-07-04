//
//  HomeViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/03.
//

import SwiftUI
import HealthKit

final class HomeViewModel: ObservableObject {
    
    private var hkManager: HealthKitManager?
    
    @Published var kcals: [Kcal] = []
    
    @Published var kcalPerWeek: Double = 0.0
    
    init() {
        hkManager = HealthKitManager()
    }
    
    func loadStats() {
        if let hkManager = hkManager {
            hkManager.requestAuthorization { result in
                if let result = result {
                    if result {
                        hkManager.calculateKcal { [unowned self] statCollection in
                            if let statCollection = statCollection {
                                DispatchQueue.main.async {
                                    print("업데이트 \(statCollection)")
                                    self.updateUIFromStatistics(statCollection)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateUIFromStatistics(_ statCollection: HKStatisticsCollection) {
        
        guard let startDate = Calendar.current.date(byAdding: .day,
                                                    value: -7,
                                                    to: Date()) else { return }
        let endDate = Date()
        
        /// 시작 날짜부터 종료 날짜까지의 모든 시간 간격에 대한 통계 개체를 열거합니다.
        statCollection
            .enumerateStatistics(from: startDate, to: endDate) { statCollection, _ in
                
                let count = statCollection.sumQuantity()?.doubleValue(for: .kilocalorie())
                guard let count = count else {return }
                
                let kcal = Kcal(count: count, date: statCollection.startDate)
                self.kcals.append(kcal)
            }
        
        kcalPerWeek = kcals.reduce(0) { partialResult, kcal in
            partialResult + kcal.count
        }
    }
    
}
