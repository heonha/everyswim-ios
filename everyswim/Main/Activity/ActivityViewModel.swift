//
//  ActivityViewModel.swift
//  swimmers
//
//  Created by HeonJin Ha on 9/29/23.
//

import Foundation
import UIKit
import Combine

final class ActivityViewModel: BaseViewModel, IOProtocol {
    
    struct Input {
        let viewWillAppeared: AnyPublisher<Void, Never>
        let selectedSegment: AnyPublisher<Int, Never>
        let tappedTitleMenu: AnyPublisher<Void, Never>
        let viewSwipedRight: AnyPublisher<Void, Never>
        let viewSwipedLeft: AnyPublisher<Void, Never>
        let scrollViewLayoutLoaded: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let presentDatePicker: AnyPublisher<(ActivityDataRange, Date), Never>
        let changeSegment: AnyPublisher<ActivityDataRange, Never>
        let remakeTableViewLayout: AnyPublisher<Void, Never>
        let updateSummaryData: AnyPublisher<SwimSummaryViewModel, Never>
        let updateLoadingState: AnyPublisher<Bool, Never>
    }
        
    private let healthStore = SwimDataStore.shared
    
    @Published var summaryData: SwimSummaryViewModel?
    private (set)var presentedData = CurrentValueSubject<[SwimMainData], Never>([])
    private var selectedSegmentSubject = CurrentValueSubject<ActivityDataRange, Never>(.monthly)

    // MARK: - Picker Objects
    @Published var selectedDate: Date = Date()
    
    override init() {
        super.init()
    }
    
    // MARK: - Pickers Data
    
    // swiftlint:disable:next function_body_length
    func transform(input: Input) -> Output {
        // segment changed
        let changeSegment = Publishers
            .CombineLatest(input.selectedSegment, input.viewWillAppeared)
            .compactMap { index, _ in
               return ActivityDataRange(rawValue: index)
            }
            .map { [weak self] type in
                self?.segmentAction(type: type)
                return type
            }
            .eraseToAnyPublisher()
        
        // 타이틀 메뉴 탭 -> present Datepicker
        let presentDatePicker = input
            .tappedTitleMenu
            .compactMap { _ in
                return (self.selectedSegmentSubject.value, self.selectedDate)
            }
            .eraseToAnyPublisher()
        
        let remakeTableViewLayout = input.scrollViewLayoutLoaded
            .compactMap { isLoaded -> Void? in
                guard isLoaded == true else { return nil }
            }
            .eraseToAnyPublisher()
        
        let updateSummaryData = $summaryData
            .compactMap { data in
                return data
            }
            .eraseToAnyPublisher()
                
        let updateLoadingState = isLoading
            .eraseToAnyPublisher()

        return Output(presentDatePicker: presentDatePicker,
                      changeSegment: changeSegment,
                      remakeTableViewLayout: remakeTableViewLayout,
                      updateSummaryData: updateSummaryData,
                      updateLoadingState: updateLoadingState
        )
    }

    // MARK: Methods
    private func segmentAction(type: ActivityDataRange) {
        self.isLoading.send(true)
        self.getData(type)
        self.selectedSegmentSubject.send(type)
        self.isLoading.send(false)
    }

    private func getData(_ type: ActivityDataRange) {
        var totalData: [SwimMainData]
        
        switch type {
        case .weekly:
            totalData = healthStore.getWeeklyData(date: Date())
        case .monthly:
            totalData = healthStore.getMonthlyData()
        case .yearly:
            totalData = healthStore.getYearlyData()
        case .total:
            totalData = healthStore.getAllData()
        }
        
        setSummaryData()
        
        DispatchQueue.main.async {
            self.presentedData.send(totalData)
        }
    }
    
    private func setSummaryData() {
        presentedData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.summaryData = self?.healthStore.getSummaryData(data)
            }
            .store(in: &cancellables)
    }
        
    // MARK: - Picker Objects
    
}
