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
    
    required init(usecase: LoginUseCaseProtocol = LoginUseCase()) {
        self.usecase = usecase
        self.model = LoginModel()
    }
    
    func login(userName: String, password: String) {
        usecase.login(username: userName, password: password) { response in
            switch response {
            case .success(let user):
                self.model.user = user
                self.onSuccess?(user)
                break
            case .failure(let error):
                self.onError?(error.message())
                print(error)
                break
            }
        }
    }
}
