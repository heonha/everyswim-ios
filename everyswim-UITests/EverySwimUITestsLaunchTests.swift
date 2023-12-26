//
//  everyswim_UITestsLaunchTests.swift
//  everyswim-UITests
//
//  Created by HeonJin Ha on 12/25/23.
//

import XCTest

final class EverySwimUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 앱 실행 후 스크린샷을 찍기 전에 수행할 단계를 여기에 삽입합니다.
        // 테스트 계정에 로그인하거나 앱 어딘가를 탐색하는 등
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
