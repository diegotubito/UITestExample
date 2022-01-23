//
//  LoginUseCase.swift
//  Login
//
//  Created by David Diego Gomez on 21/01/2022.
//

import Foundation

protocol LoginUseCaseProtocol: AnyObject {
    init(repository: ApiServiceProtocol)
    func login(username: String, password: String, completionBlock: @escaping (Result<User, APIError>) -> Void)
}

class LoginUseCase: LoginUseCaseProtocol {
    var repository: ApiServiceProtocol
    
    required init(repository: ApiServiceProtocol = ApiServiceFactory.create()) {
        self.repository = repository
    }
    
    func login(username: String, password: String, completionBlock: @escaping (Result<User, APIError>) -> Void) {
        let request = Request.endpoint(to: .Login(userName: username, password: password))
        repository.fetch(request: request, completionBlock: {response in
            completionBlock(response)
        })
    }
}
