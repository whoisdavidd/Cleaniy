//
//  MovelahUITests.swift
//  MovelahUITests
//
//  Created by David Kumar on 12/6/24.
//

import XCTest

final class CleaniyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // Launch the application for each test
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCleaniyActions() throws {
        let app = XCUIApplication()
        
        // 1. Test Move Action
        app.pickers.buttons["Move"].tap()
        app.buttons["Confirm"].tap()
        XCTAssert(app.staticTexts["Cleaniy has moved your items yay!"].exists, "Move action did not result in the expected notification.")
        
        // 2. Test Delete Action
        app.pickers.buttons["Delete"].tap()
        app.buttons["Confirm"].tap()
        XCTAssert(app.staticTexts["Cleaniy has cleaned your desktop yay!"].exists, "Delete action did not result in the expected notification.")
        
        // 3. Test Cancel Action (for Move)
        app.pickers.buttons["Move"].tap()
        app.buttons["Cancel"].tap()
        XCTAssertFalse(app.staticTexts["Cleaniy has moved your items yay!"].exists, "Cancel action did not properly cancel the move action.")
        
        // 4. Test Cancel Action (for Delete)
        app.pickers.buttons["Delete"].tap()
        app.buttons["Cancel"].tap()
        XCTAssertFalse(app.staticTexts["Cleaniy has cleaned your desktop yay!"].exists, "Cancel action did not properly cancel the delete action.")
    }
}
