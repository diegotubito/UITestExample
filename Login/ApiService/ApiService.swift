//
//  ApiService.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

class ApiServiceFactory {
    static func create() -> ApiServiceProtocol {
        if ProcessInfo.processInfo.environment["ENV"] == "NOT_TESTING" {
            return ApiService()
        } else {
            return ApiServiceMock()
        }
    }
}

protocol ApiServiceProtocol {
    func fetch(request: URLRequest, completionBlock: @escaping (Result<Data, APIError>) -> Void)
}

class ApiService: ApiServiceProtocol {
    func fetch(request: URLRequest, completionBlock: @escaping (Result<Data, APIError>) -> Void) {
     
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data , urlresponse, error in
            if let error = error {
                completionBlock(.failure(APIError.customError(message: error.localizedDescription, code: 500)))
                return
            }
            
            guard let data = data,
                  let response = urlresponse as? HTTPURLResponse else {
                      completionBlock(.failure(APIError.serverError))
                      return
                  }
            
            let status = response.statusCode
            guard (200...299).contains(status) else {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let message : String = (json?["message"] as? String) ?? "error code \(status)"
                completionBlock(.failure(.customError(message: message, code: status)))
                return
            }
            completionBlock(.success(data))
            
        })
        task.resume()
    }
}

enum APIError: Equatable, Error, CustomStringConvertible {
    case invalidToken
    case serverError
    case notFound
    case notHandleError
    case customError(message: String, code: Int)
    
    func message() -> String {
        switch self {
        case .invalidToken:
            return "401_INVALID_TOKEN"
        case .serverError:
            return "500_SERVER_ERROR"
        case .notFound:
            return "404_NOT_FOUND"
        case .notHandleError:
            return "NOT_HANDLE_ERROR"
        case .customError(message: let message, code: _):
            return message
        }
    }
    
    func code() -> Int {
        switch self {
        case .invalidToken:
            return 401
        case .serverError:
            return 500
        case .notFound:
            return 404
        case .notHandleError:
            return -1
        case .customError(message: _, code: let code):
            return code
        }
    }
    
    var description: String {
        return "🧨⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽\nmessage: \(message())\ncode: \(code())\n⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺"
    }
}
