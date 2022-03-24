//
//  LoginUseCase.swift
//  Login
//
//  Created by David Diego Gomez on 21/01/2022.
//

import Foundation


protocol LoginUseCaseProtocol: AnyObject {
    init(repository: LoginRepositoryProtocol)
    func login(username: String, password: String, completion: @escaping CustomResult)
}

class LoginUseCase: LoginUseCaseProtocol {
    var repository: LoginRepositoryProtocol
    
    required init(repository: LoginRepositoryProtocol = LoginRepository()) {
        self.repository = repository
    }
    
    func login(username: String, password: String, completion: @escaping CustomResult) {
        let input = LoginDataSource.Request(email: username, password: password)
        repository.doLogin(body: input, token: "") { result in
            completion(result)
        }
        return 
    }
}

class LoginUseCaseMock: LoginUseCaseProtocol {
    var repository: LoginRepositoryProtocol
    
    required init(repository: LoginRepositoryProtocol = LoginRepositoryMock() ) {
        self.repository = repository
    }
    
    func login(username: String, password: String, completion: @escaping CustomResult) {
        let input = LoginDataSource.Request(email: username, password: password)
        repository.doLogin(body: input, token: "") { result in
            completion(result)
        }
        return
    }
}
