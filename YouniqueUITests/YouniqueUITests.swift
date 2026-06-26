//
//  YouniqueUITests.swift
//  YouniqueUITests
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import XCTest

final class YouniqueUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAppLaunchesToHomepage() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST_SKIP_ONBOARDING")
        app.launch()

        // App-titel zichtbaar (taal-onafhankelijk)
        XCTAssertTrue(app.staticTexts["Younique"].waitForExistence(timeout: 5))

        // De primaire actieknop bestaat (via accessibility identifier)
        XCTAssertTrue(app.buttons["discoverButton"].exists)
    }

    @MainActor
    func testDiscoverButtonOpensOverlay() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST_SKIP_ONBOARDING")
        app.launch()

        let discoverButton = app.buttons["discoverButton"]
        XCTAssertTrue(discoverButton.waitForExistence(timeout: 5))
        discoverButton.tap()

        let wandButton = app.buttons["spinAgainButton"]
        XCTAssertTrue(wandButton.waitForExistence(timeout: 10))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let app = XCUIApplication()
            app.launchArguments.append("UI_TEST_SKIP_ONBOARDING")
            app.launch()
        }
    }
}
