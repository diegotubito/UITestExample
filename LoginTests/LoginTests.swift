//
//  LoginTests.swift
//  LoginTests
//
//  Created by David Diego Gomez on 07/12/2021.
//

import XCTest
@testable import Login

class LoginTests: XCTestCase {

    func testLoginSuccess() {
        let service: ApiServiceProtocol = ApiServiceMock()
        let exp = expectation(description: "")
        
        let request = Request.endpoint(to: .Login(userName: "", password: ""))
        service.fetch(request: request) { result in
            XCTAssertNotNil(result, "data should not be nil")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
