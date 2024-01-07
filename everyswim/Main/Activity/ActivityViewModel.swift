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
        let selectedDateInDatePicker: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let presentDatePicker: AnyPublisher<ActivityDataRange, Never>
        let changeSegment: AnyPublisher<ActivityDataRange, Never>
        let changeSegmentRight: AnyPublisher<Int, Never>
        let changeSegmentLeft: AnyPublisher<Int, Never>
        let remakeTableViewLayout: AnyPublisher<Void, Never>
        let updateSummaryData: AnyPublisher<SwimSummaryViewModel, Never>
        let updateDataFromSelectedDate: AnyPublisher<(ActivityDataRange, Date), Never>
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
        
        let changeSegment = Publishers
            .CombineLatest(input.selectedSegment, input.viewWillAppeared)
            .compactMap { index, _ in
               return ActivityDataRange(rawValue: index)
            }
            .map { [weak self] type in
                self?.isLoading.send(true)
                self?.segmentAction(type: type)
                return type
            }
            .eraseToAnyPublisher()
        
        let presentDatePicker = input.tappedTitleMenu
            .compactMap { _ in
                return self.selectedSegmentSubject.value
            }
            .eraseToAnyPublisher()
        
        let changeSegmentLeft = Publishers
            .CombineLatest(input.viewSwipedLeft, input.selectedSegment)
            .map { [unowned self] _, selectedSegment -> Int in
                let index = selectedSegment + 1
                guard let selected = ActivityDataRange(rawValue: index) else { return 3 }
                let type =  ActivityDataRange(rawValue: selectedSegment)!
                self.segmentAction(type: type)
                return selectedSegment
            }
            .eraseToAnyPublisher()
        
        let changeSegmentRight =  Publishers
            .CombineLatest(input.viewSwipedRight, input.selectedSegment)
            .map { [unowned self] _, selectedSegment -> Int in
                let type =  ActivityDataRange(rawValue: selectedSegment)!
                self.segmentAction(type: type)
                return selectedSegment
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
        
        let updateDataFromSelectedDate = input
            .selectedDateInDatePicker
            .receive(on: DispatchQueue.main)
            .compactMap { _ in
                print("전달")
                let selectedSegment = self.selectedSegmentSubject.value
                return (selectedSegment, Date())
            }
            .eraseToAnyPublisher()
        
        let initSelectedSegment = input.viewWillAppeared
            .map { _ in
                return
            }
        
        let updateLoadingState = isLoading
            .eraseToAnyPublisher()

        return Output(presentDatePicker: presentDatePicker,
                      changeSegment: changeSegment,
                      changeSegmentRight: changeSegmentRight,
                      changeSegmentLeft: changeSegmentLeft,
                      remakeTableViewLayout: remakeTableViewLayout,
                      updateSummaryData: updateSummaryData,
                      updateDataFromSelectedDate: updateDataFromSelectedDate,
                      updateLoadingState: updateLoadingState
        )
    }

    // MARK: Methods
    private func segmentAction(type: ActivityDataRange) {
        self.getData(type)
        self.selectedSegmentSubject.send(type)
    }

    private func getData(_ type: ActivityDataRange) {
        self.isLoading.send(true)
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
            self.isLoading.send(false)
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
