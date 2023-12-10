//
//  AddressTests.swift
//  everyswim-tests
//
//  Created by HeonJin Ha on 12/10/23.
//


import XCTest
import Combine
@testable import everyswim

class RegionSearchManagerTests: XCTestCase {
    
    var regionSearchManager: RegionSearchManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        regionSearchManager = RegionSearchManager()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        regionSearchManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetAllRegions() {
        // Given
        let expectation = expectation(description: "Fetching regions")
        
        // When
        regionSearchManager.getAllRegions()
        
        // Then
        regionSearchManager.$regions
            .receive(on: DispatchQueue.global())
            .filter { !$0.isEmpty }
            .sink { region in
                XCTAssertEqual(region.count, 17)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
