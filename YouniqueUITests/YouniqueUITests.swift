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
        app.launch()

        // App-titel zichtbaar
        XCTAssertTrue(app.staticTexts["Younique"].waitForExistence(timeout: 5))

        // Default section labels aanwezig
        XCTAssertTrue(app.staticTexts["Naamtype"].exists)
        XCTAssertTrue(app.staticTexts["Aantal posities"].exists)
        XCTAssertTrue(app.staticTexts["Lettergrepen kiezen"].exists)
    }

    @MainActor
    func testDiscoverButtonOpensOverlay() throws {
        let app = XCUIApplication()
        app.launch()

        let discoverButton = app.buttons["Ontdek een naam"]
        XCTAssertTrue(discoverButton.waitForExistence(timeout: 5))
        discoverButton.tap()

        // Wacht tot de slot-machine animatie klaar is en de naam zichtbaar wordt.
        // De animatie duurt enkele seconden afhankelijk van aantal reels.
        Thread.sleep(forTimeInterval: 4)

        // De heart-knop (favoriet toggle) of het kruisje moet bestaan na completion.
        // We checken op "Nog een keer draaien" (toverstaf-knop accessibility label).
        let wandButton = app.buttons["Nog een keer draaien"]
        XCTAssertTrue(wandButton.waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
