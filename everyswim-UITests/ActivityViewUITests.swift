//
//  ActivityViewUITests.swift
//  everyswim-UITests
//
//  Created by HeonJin Ha on 12/25/23.
//

import XCTest

class ActivityViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testActivityViewComponents() throws {
        // Assuming 'activityView' is an accessibility identifier set for ActivityView
        let activityView = app.otherElements["activityView"]
        XCTAssertTrue(activityView.exists, "ActivityView does not exist.")

        // Check if the segment control is present
        let segmentControl = activityView.segmentedControls["activityTypeSegmentControl"]
        XCTAssertTrue(segmentControl.exists, "Segment control not found.")

        // Test if the title label is present
        let titleLabel = activityView.staticTexts["titleLabel"]
        XCTAssertTrue(titleLabel.exists, "Title label not found.")

        // Test if tableView is present
        let tableView = activityView.tables["tableView"]
        XCTAssertTrue(tableView.exists, "Table view not found.")

        // Add more assertions as needed
    }

    func testSegmentControlInteraction() throws {
        let segmentControl = app.segmentedControls["activityTypeSegmentControl"]

        // Test tapping on different segments
        segmentControl.buttons.element(boundBy: 0).tap() // Taps the first segment
        segmentControl.buttons.element(boundBy: 1).tap() // Taps the second segment

        // Add assertions to verify changes after interaction
    }

    // Add more tests for other interactions and components
}
