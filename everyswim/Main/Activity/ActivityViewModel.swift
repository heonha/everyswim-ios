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
        let presentDatePicker: AnyPublisher<ActivityDataRange, Never>
        let changeSegment: AnyPublisher<ActivityDataRange, Never>
        let remakeTableViewLayout: AnyPublisher<Void, Never>
        let updateSummaryData: AnyPublisher<(SwimSummaryViewModel?, ActivityDataRange), Never>
        let updateLoadingState: AnyPublisher<Bool, Never>
    }
        
    private let healthStore = SwimDataStore.shared
    
    private var targetDate = CurrentValueSubject<ActivityDatePickerViewData?, Never>(nil)
    private (set) var summaryData = CurrentValueSubject<SwimSummaryViewModel?, Never>(nil)
    private (set) var presentedData = CurrentValueSubject<[SwimMainData], Never>([])
    private var selectedSegmentSubject = CurrentValueSubject<ActivityDataRange, Never>(.monthly)

    // MARK: - Picker Objects
    
    override init() {
        super.init()
    }
    
    // MARK: - Pickers Data
    
    // swiftlint:disable:next function_body_length
    func transform(input: Input) -> Output {
        // segment changed
        let changeSegment = Publishers
            .CombineLatest(input.selectedSegment, input.viewWillAppeared)
            .compactMap { index, _ -> ActivityDataRange? in
                return .init(rawValue: index)
            }
            .map { [weak self] type in
                self?.segmentAction(type: type)
                return type
            }
            .eraseToAnyPublisher()
        
        // 타이틀 메뉴 탭 -> present Datepicker
        let presentDatePicker = input
            .tappedTitleMenu
            .filter { _ in
                self.selectedSegmentSubject.value == .total ? false : true
            }
            .compactMap { _ in
                return self.selectedSegmentSubject.value
            }
            .eraseToAnyPublisher()
        
        let remakeTableViewLayout = input.scrollViewLayoutLoaded
            .compactMap { isLoaded -> Void? in
                guard isLoaded == true else { return nil }
            }
            .eraseToAnyPublisher()
        
        let updateSummaryData = Publishers
            .CombineLatest(summaryData.eraseToAnyPublisher(), selectedSegmentSubject.eraseToAnyPublisher())
            .compactMap { ($0, $1) }
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
        self.targetDate.send(nil)
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
                guard let self = self else { return }
                let summaryData = healthStore.getSummaryData(data)
                self.summaryData.send(summaryData)
            }
            .store(in: &cancellables)
    }
    
    func getPresentedDate() -> ActivityDatePickerViewData? {
        return self.targetDate.value
    }
        
    // MARK: - Picker Objects
    // 선택한 데이터 불러오기
    func updateSelectedRangesData(_ data: ActivityDatePickerViewData) {
        let date = data.date
        
        switch data.range {
        case .weekly:
            let fetchedData = healthStore.getWeeklyData(date: date)
            self.presentedData.send(fetchedData)
        case .monthly:
            let fetchedData = healthStore.getMonthlyData(date)
            self.presentedData.send(fetchedData)
        case .yearly:
            let yearlyData = healthStore.getYearlyData(date)
            self.presentedData.send(yearlyData)
        case .total:
            return
        }
        
        self.targetDate.send(data)
    }

}
