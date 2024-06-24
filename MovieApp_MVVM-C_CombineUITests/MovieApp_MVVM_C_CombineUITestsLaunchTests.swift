//
//  MovieApp_MVVM_C_CombineUITestsLaunchTests.swift
//  MovieApp_MVVM-C_CombineUITests
//
//  Created by Wajih Benabdessalem on 6/24/24.
//

import XCTest

final class MovieApp_MVVM_C_CombineUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
