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
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    return
                }
                self.onSuccess?(user)
                break
            case .failure(let error):
                self.onError?(error.localizedDescription)
                break
            }
        }
    }
}


class LoginUseCaseFactory {
    static let shared = LoginUseCaseFactory()
    
    static func create() -> LoginUseCaseProtocol {
        let param = ProcessInfo.processInfo.environment["ENV"]
        if param == "NOT_TESTING" {
            return LoginUseCase()
        }
        return LoginUseCaseMock()
    }
}


