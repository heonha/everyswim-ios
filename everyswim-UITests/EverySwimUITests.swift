//
//  everyswim_UITests.swift
//  everyswim-UITests
//
//  Created by HeonJin Ha on 12/25/23.
//

import XCTest

final class EverySwimUITests: XCTestCase {

    override func setUpWithError() throws {
        // 여기에 설정 코드를 입력합니다. 이 메서드는 클래스의 각 테스트 메서드를 호출하기 전에 호출됩니다.
        // UI 테스트에서는 일반적으로 오류가 발생하면 즉시 중지하는 것이 가장 좋습니다.
        continueAfterFailure = false

        // UI 테스트에서는 테스트를 실행하기 전에 인터페이스 방향과 같은 초기 상태를 설정하는 것이 중요합니다. setUp 메소드는 이를 수행하기에 좋은 장소입니다.
    }

    override func tearDownWithError() throws {
        // 여기에 teardown 코드를 입력합니다. 이 메서드는 클래스의 각 테스트 메서드가 호출된 후에 호출됩니다.
    }

    func testExample() throws {
        // UI 테스트는 테스트하는 애플리케이션을 시작해야 합니다.
        let app = XCUIApplication()
        app.launch()

        // XCTAssert 및 관련 함수를 사용하여 테스트가 올바른 결과를 생성하는지 확인합니다.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // 애플리케이션을 실행하는 데 걸리는 시간을 측정합니다.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
