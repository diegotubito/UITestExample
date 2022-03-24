//
//  LoginRepository.swift
//  Login
//
//  Created by David Diego Gomez on 24/01/2022.
//

import Foundation


typealias CustomResult = (Result<Data, APIError>) -> Void

protocol LoginRepositoryProtocol {
    func doLogin(body: LoginDataSource.Request, token: String, completion: @escaping CustomResult)
}

class LoginRepository: ApiCall, LoginRepositoryProtocol {
 
    func doLogin(body: LoginDataSource.Request, token: String, completion: @escaping CustomResult) {
        config.path = "v1/firebase/auth/login"
        config.method = "POST"
        
        addBody(body)
        
        apiCallData { result in completion(result) }
    }
}

class LoginRepositoryMock: ApiCallMock, LoginRepositoryProtocol {
    func doLogin(body: LoginDataSource.Request, token: String, completion: @escaping CustomResult) {
        api(filename: "LoginSuccessResponse") { result in
            completion(result)
        }
    }
}
