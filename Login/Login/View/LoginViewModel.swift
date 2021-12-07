//
//  LoginViewModel.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

protocol LoginViewModelProtocol {
    init(withView view: LoginViewProtocol, service: ApiService)
    func login(userName: String, password: String)
}

protocol LoginViewProtocol {
    func showSuccess(dictionary: [String: Any])
    func showError(message: String)
}

class LoginViewModel: LoginViewModelProtocol {
    var view: LoginViewProtocol
    var service: ApiService
    
    required init(withView view: LoginViewProtocol, service: ApiService) {
        self.view = view
        self.service = service
    }
    
    func login(userName: String, password: String) {
        
        let request = Request.endpoint(to: .helloWorld)
        service.downloadData(request: request, completionBlock: {response in
            switch response {
            case .success(let data):
                guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                print(dictionary)
                self.view.showSuccess(dictionary: dictionary)
                break
            case .failure(let error):
                print(error.message())
                print(error.code())
                print(error)
                break
            }
        })
    }
}
