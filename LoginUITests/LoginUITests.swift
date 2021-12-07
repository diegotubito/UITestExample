//
//  LoginUITests.swift
//  LoginUITests
//
//  Created by David Diego Gomez on 07/12/2021.
//

import XCTest

class LoginUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.buttons["loginButtonMain"].tap()
        sleep(1)
        
        let usernameTextField = app.textFields["loginUserNameTextField"]
        let passwordTextField = app.textFields["loginPasswordTextField"]
        
        usernameTextField.tap()
        usernameTextField.typeText("diegodavid@icloud.com")
        
        passwordTextField.tap()
        passwordTextField.typeText("admin1234")
        
        app.buttons["loginButton"].tap()
        
        sleep(2)
        
        let loginResultLabel = app.staticTexts["loginResultLabel"]
          
        XCTAssertEqual("success", loginResultLabel.label)
     }
}