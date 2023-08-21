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
    func test_Date_StringFromTimeInterval_AllAccertPass() {
        
        let fortyFiveMinute = TimeInterval(2700)
        let oneHour = TimeInterval(3600)
        let oneHourTwoMinute = TimeInterval(3720)
        let oneHourTwoneHourFiftyMinute = TimeInterval(4500)

        let fortyFiveMinuteString = fortyFiveMinute.toRelativeTime(.hourMinute)
        let oneHourString = oneHour.toRelativeTime(.hourMinute)
        let oneHourTwoMinuteString = oneHourTwoMinute.toRelativeTime(.hourMinute)
        let oneHourTwoneHourFiftyMinuteString = oneHourTwoneHourFiftyMinute.toRelativeTime(.hourMinute)
        
        XCTAssertEqual("45분", fortyFiveMinuteString)
        XCTAssertEqual("1시간", oneHourString)
        XCTAssertEqual("1시간 2분", oneHourTwoMinuteString)
        XCTAssertEqual("1시간 15분", oneHourTwoneHourFiftyMinuteString)

    }
    
    // test_[struct or claas]]_[Variable & Funtions]_[Expected Result]
    func test_Date_relativeDate_1hoursAgo() {
        
        let oneHoursAgoDate = Date.now.addingTimeInterval(-3600)
        
        let oneHoursAgo = Date.relativeDate(from: oneHoursAgoDate)

        print("Relative date is: \(oneHoursAgo)")
        
        XCTAssertEqual("1시간 전", oneHoursAgo)
    }
    
}
