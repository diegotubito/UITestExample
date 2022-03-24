//
//  LoginUITests.swift
//  LoginUITests
//
//  Created by David Diego Gomez on 07/12/2021.
//

import XCTest

class LoginUITests: XCTestCase {
    func testLoginSuccess() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        // Mock response filename
        app.launchEnvironment = ["FILENAME":"LoginSuccessResponse"]
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.buttons["loginButtonMain"].tap()
          
        let usernameTextField = app.textFields["loginUserNameTextField"]
        let passwordTextField = app.textFields["loginPasswordTextField"]
        
        usernameTextField.tap()
        usernameTextField.typeText("diegodavid@icloud.com")
        
        
        passwordTextField.tap()
        passwordTextField.typeText("admin1234")
        
        app.buttons["loginButton"].tap()
        let loginResultLabel = app.staticTexts["loginResultLabel"]
        
        XCTAssertEqual("Develop - ddg - from mock file", loginResultLabel.label)
     }
    
    
    func testLoginWrongPassword() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        // mock server will send a failure response
        app.launchArguments = ["-testFail"]
        // Mock response filename
        app.launchEnvironment = ["FILENAME":"LoginWrongPassword"]
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.buttons["loginButtonMain"].tap()
        
        let usernameTextField = app.textFields["loginUserNameTextField"]
        let passwordTextField = app.textFields["loginPasswordTextField"]
        
        usernameTextField.tap()
        usernameTextField.typeText("diegodavid@icloud.com")
        
        
        passwordTextField.tap()
        passwordTextField.typeText("admin12345")
        
        app.buttons["loginButton"].tap()
        let loginResultLabel = app.staticTexts["loginResultLabel"]
        
        XCTAssertEqual("The password is invalid or the user does not have a password.", loginResultLabel.label)
    }
}
