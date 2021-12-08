//
//  ApiServiceMock.swift
//  LoginTests
//
//  Created by David Diego Gomez on 08/12/2021.
//

import Foundation
@testable import Login

class ApiServiceMock: ApiServiceProtocol {
    var complete: ((Data?, APIError?) -> ())?
    
    init(_ complete: ((Data?, APIError?) -> ())? = nil) {
        self.complete = complete
    }
    
    //this method is used in ui test
    func fetch(request: URLRequest, completionBlock: @escaping (Result<Data, APIError>) -> Void) {
        let bundle = Bundle(for: ApiServiceMock.self)
        
        guard let data = readLocalFile(bundle: bundle, forName: "LoginSuccessResponse") else {
            completionBlock(.failure(APIError.notFound))
            return
        }
    
        completionBlock(.success(data))
    }

    func readLocalFile(bundle: Bundle, forName name: String) -> Data? {
        let bundlePath = bundle.path(forResource: name, ofType: "json")
        let jsonData = try? String(contentsOfFile: bundlePath!).data(using: .utf8)
        return jsonData
    }
   
}

