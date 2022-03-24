//
//  LoginRepository.swift
//  Login
//
//  Created by David Diego Gomez on 24/01/2022.
//

import Foundation

typealias CustomResult<T: Decodable> = (Result<T, APIError>) -> Void

protocol LoginRepositoryProtocol {
    func doLogin(requestBody: LoginDataSource.Request, token: String, completion: @escaping CustomResult<User>)
}

class LoginRepository: ApiCall, LoginRepositoryProtocol {
 
    func doLogin(requestBody: LoginDataSource.Request, token: String, completion: @escaping CustomResult<User>) {
        config.path = "v1/firebase/auth/login"
        config.method = "POST"
        
        addRequestBody(requestBody)
        
        apiCall { result in completion(result) }
    }
}

class LoginRepositoryMock: ApiCallMock, LoginRepositoryProtocol {
    func doLogin(requestBody: LoginDataSource.Request, token: String, completion: @escaping CustomResult<User>) {
        api(filename: "LoginSuccessResponse") { result in
            completion(result)
        }
    }
}
