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
    
    var onSuccess: ((LoginModel) -> ())? { get set }
    var onError: ((String) -> ())? { get set }
}

class LoginViewModel: LoginViewModelProtocol {
    var onSuccess: ((LoginModel) -> ())?
    var onError: ((String) -> ())?
    
    var usecase: LoginUseCaseProtocol
    
    required init(usecase: LoginUseCaseProtocol = LoginUseCase() ) {
        self.usecase = usecase
    }
    
    func login(userName: String, password: String)  {
        self.usecase.login(username: userName, password: password) { result in
            switch result {
            case .success(let user):
                self.onSuccess?(LoginModel(user: user))
                break
            case .failure(let error):
                self.onError?(error.message())
                break
            }
        }
    }
}
