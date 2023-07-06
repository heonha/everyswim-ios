//
//  CustomCalculatorTests.swift
//  swimmersTests
//
//  Created by HeonJin Ha on 2023/07/06.
//

import XCTest
import Foundation
@testable import swimmers

class CustomCalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // TimeInterval을 String으로 변경 테스트
    func testStringFromTimeInterval() {
        
        let fortyFiveMinute = TimeInterval(2700)
        let oneHour = TimeInterval(3600)
        let oneHourTwoMinute = TimeInterval(3720)
        let oneHourTwoneHourFiftyMinute = TimeInterval(4500)

        let fortyFiveMinuteString = fortyFiveMinute.stringFromTimeInterval()
        let oneHourString = oneHour.stringFromTimeInterval()
        let oneHourTwoMinuteString = oneHourTwoMinute.stringFromTimeInterval()
        let oneHourTwoneHourFiftyMinuteString = oneHourTwoneHourFiftyMinute.stringFromTimeInterval()
        
        XCTAssertEqual("45분", fortyFiveMinuteString)
        XCTAssertEqual("1시간", oneHourString)
        XCTAssertEqual("1시간 2분", oneHourTwoMinuteString)
        XCTAssertEqual("1시간 15분", oneHourTwoneHourFiftyMinuteString)
        
    }
    
}
