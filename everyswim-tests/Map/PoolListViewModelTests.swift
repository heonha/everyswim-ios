//
//  PoolListViewModelTests.swift
//  everyswim-tests
//
//  Created by HeonJin Ha on 12/10/23.
//

import Foundation
import XCTest
import Combine
@testable import everyswim

class PoolListViewModelTests: XCTestCase {
    
    var sut: PoolViewModel!
    var regionSearchManager: RegionSearchManager!
    var locationManager: DeviceLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        locationManager = .shared
        regionSearchManager = .init()
        sut = PoolViewModel(locationManager: locationManager, regionSearchManager: regionSearchManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        locationManager = nil
        super.tearDown()
    }
    
    /// 수영장 검색결과가 잘 받아와지는지 확인
    func test_fetchingPool_returnsNonEmptyResults() {
        // Given
        let expectation = expectation(description: "Fetching regions")

        // When
        sut.findLocation(query: "서울시구로구수영장")
        
        // Then
        sut.places
            .receive(on: DispatchQueue.global())
            .filter { !$0.isEmpty }
            .sink { locations in
                print(locations)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

