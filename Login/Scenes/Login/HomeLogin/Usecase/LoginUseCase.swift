//
//  LoginUseCase.swift
//  Login
//
//  Created by David Diego Gomez on 21/01/2022.
//

import Foundation

protocol LoginUseCaseProtocol: AnyObject {
    init(repository: LoginRepositoryProtocol)
    func login(username: String, password: String, completion: @escaping CustomResult<User>)
}

class LoginUseCase: LoginUseCaseProtocol {
    var repository: LoginRepositoryProtocol
    
    required init(repository: LoginRepositoryProtocol = LoginRepositoryFactory.create() ) {
        self.repository = repository
    }
    
    func login(username: String, password: String, completion: @escaping CustomResult<User>) {
        let requestBody = LoginDataSource.Request(email: username, password: password)
        repository.doLogin(requestBody: requestBody, token: "") { result in
            completion(result)
        }
        return 
    }
}
