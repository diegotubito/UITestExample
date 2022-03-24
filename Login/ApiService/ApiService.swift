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
    func fetch(request: URLRequest, completionBlock: @escaping (Result<User, APIError>) -> Void)
    func cancel()
}

class ApiService: ApiServiceProtocol {
    let session: URLSession
    var task: URLSessionDataTask!
    
    init() {
        session = URLSession.shared
    }
    
    func cancel() {
        guard let task = task else { return }
        task.cancel()
    }
    
    func fetch<T: Decodable>(request: URLRequest, completionBlock: @escaping (Result<T, APIError>) -> Void) {
        api(request: request) { response in
            switch(response) {
            case .success(let data):
            
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionBlock(.success(decodedData))
                } catch {
                    completionBlock(.failure(.serialize))
                }
       
                break
            case .failure(let error):
                completionBlock(.failure(error))
                break
            }
        }
    }
    
    func api(request: URLRequest, completionBlock: @escaping (Result<Data, APIError>) -> Void) {
     
         task = session.dataTask(with: request, completionHandler: {data , urlresponse, error in
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
    case serialize
    case request
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
        case .request:
            return "REQUEST_ERROR"
        case .serialize:
            return "SERIALIZE_ERROR"
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
        case .serialize:
            return 400
        case .customError(message: _, code: let code):
            return code
        case .request:
            return 400
        }
    }
    
    var description: String {
        return "🧨⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽\nmessage: \(message())\ncode: \(code())\n⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺"
    }
}
