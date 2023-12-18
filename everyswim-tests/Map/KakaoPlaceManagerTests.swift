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
    
    var sut: KakaoPlacesManager!
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
        let expectation = expectation(description: "카카오 키워드 검색 수행")
        
        sut.findPlaceFromKeyword(query: "광명시수영장", 
                                 coordinator: .init(latitude: 37.480667, longitude: 126.850454)) { result in
            switch result {
            case .success(let places):
                if !places.isEmpty {
                    expectation.fulfill()
                } else {
                    XCTFail("장소 데이터가 비어있습니다.")
                }
            case .failure(let error):
                XCTFail("오류가 발생했습니다. \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
