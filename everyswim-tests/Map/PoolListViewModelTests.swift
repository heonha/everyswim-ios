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
    
    var sut: PoolMapViewModel!
    var regionSearchManager: RegionSearchManager!
    var locationManager: DeviceLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        locationManager = .init()
        regionSearchManager = .init()
        sut = PoolMapViewModel(locationManager: locationManager, regionSearchManager: regionSearchManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        locationManager = nil
        super.tearDown()
    }
    
    func test_fetch_pool_list() {
        // Given
        let expectation = expectation(description: "Fetching regions")

        // When
        sut.findLocation(queryString: "서울시구로구수영장")
        
        // Then
        sut.$places
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

