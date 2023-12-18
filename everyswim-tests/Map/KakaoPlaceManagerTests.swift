//
//  KakaoPlaceManagerTests.swift
//  everyswim-tests
//
//  Created by HeonJin Ha on 12/18/23.
//

import Foundation
import XCTest
import Combine
@testable import everyswim

class KakaoPlaceManagerTests: XCTestCase {
    
    var sut: KakaoLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = .init()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetch_place_list() {
        // Given
        let expectation = expectation(description: "카카오 키워드 검색 수행")

        // Then
        sut.$places
            .receive(on: DispatchQueue.global())
            .filter { !$0.isEmpty }
            .sink { locations in
                print(locations)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.findPlaceFromKeyword(query: "광명시수영장", coordinator: .init(latitude: 37.480667, longitude: 126.850454))
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
}
