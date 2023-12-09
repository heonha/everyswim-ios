//
//  AddressTests.swift
//  everyswim-tests
//
//  Created by HeonJin Ha on 12/10/23.
//


import XCTest
import Combine
@testable import everyswim

class RegionSearchModelTests: XCTestCase {
    
    var regionSearchModel: RegionSearchModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        regionSearchModel = RegionSearchModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        regionSearchModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetAllRegions() {
        // Given
        let expectation = expectation(description: "Fetching regions")
        
        // When
        regionSearchModel.getAllRegions()
        
        // Then
        regionSearchModel.$currentRegionCode
            .receive(on: DispatchQueue.main)
            .filter{ $0 != ""}
            .sink { currentRegionCode in
                XCTAssertEqual(currentRegionCode, "11")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
