//
//  LoginViewModel.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

protocol LoginViewModelProtocol {
    init(service: ApiServiceProtocol)
    func login(userName: String, password: String)
    
    var onSuccess: ((User) -> ())? {get set}
    var onError: ((String) -> ())? {get set}
}

class LoginViewModel: LoginViewModelProtocol {
    var onSuccess: ((User) -> ())?
    var onError: ((String) -> ())?
    
    var service: ApiServiceProtocol
    var model: LoginModel
    
    required init(service: ApiServiceProtocol) {
        self.service = service
        self.model = LoginModel()
    }
    
    func login(userName: String, password: String) {
        
        let request = Request.endpoint(to: .Login(userName: userName, password: password))
        service.fetch(request: request, completionBlock: {response in
            switch response {
            case .success(let data):
                
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    self.onError?("could not decode")
                    return
                }
                
                self.model.user = user
                self.onSuccess?(user)
                break
            case .failure(let error):
                self.onError?(error.message())
                print(error)
                break
            }
        })
    }
}
