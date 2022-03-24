//
//  LoginViewModel.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

protocol LoginViewModelProtocol {
    init(usecase: LoginUseCaseProtocol)
    func login(userName: String, password: String)
    
    var onSuccess: ((User) -> ())? { get set }
    var onError: ((String) -> ())? { get set }
}

class LoginViewModel: LoginViewModelProtocol {
    var onSuccess: ((User) -> ())?
    var onError: ((String) -> ())?
    
    var usecase: LoginUseCaseProtocol
    var model: LoginModel
    
    required init(usecase: LoginUseCaseProtocol = LoginUseCaseFactory.create()) {
        self.usecase = usecase
        self.model = LoginModel()
    }
    
    func login(userName: String, password: String)  {
        self.usecase.login(username: userName, password: password) { result in
            switch result {
            case .success(let user):
                self.onSuccess?(user)
                break
            case .failure(let error):
                self.onError?(error.message())
                break
            }
        }
    }
}

class LoginUseCaseFactory {
    static let shared = LoginUseCaseFactory()
    
    static func create() -> LoginUseCaseProtocol {
        if ProcessInfo.processInfo.environment["ENV"] == "NOT_TESTING" {
            return LoginUseCase()
        }
        return LoginUseCaseMock()
    }
}


