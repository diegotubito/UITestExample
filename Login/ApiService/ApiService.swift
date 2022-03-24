//
//  ApiService.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

class ApiCallMock {
    var error: APIError? = APIError.customError(message: "The password is invalid or the user does not have a password.", code: 503)
    
    public func api<T: Decodable>(completionBlock: @escaping (Result<T, APIError>) -> Void) {
        let file = ProcessInfo.processInfo.environment["FILENAME"] ?? ""
        let testFail = ProcessInfo.processInfo.arguments.contains("-testFail")
        
        guard let data = readLocalFile(bundle: .main, forName: file) else {
            completionBlock(.failure(APIError.notFound))
            return
        }
        
        if testFail {
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let message : String = (json?["message"] as? String) ?? "no message"
            let code : String = (json?["code"] as? String) ?? "no code"
            
            let error = APIError.customError(message: message, code: Int(code) ?? 0)
            completionBlock(.failure(error))
            return
        }
        
        guard let register = try? JSONDecoder().decode(T.self, from: data) else {
            completionBlock(.failure(APIError.serialize))
            return
        }
        
        completionBlock(.success(register))        
    }
    
    private func readLocalFile(bundle: Bundle, forName name: String) -> Data? {
        guard let bundlePath = bundle.path(forResource: name, ofType: "json") else {
            fatalError("file \(name).json doesn't exist")
        }
        
        return try? String(contentsOfFile: bundlePath).data(using: .utf8)
    }
}

class ApiCall {
    var session: URLSession
    var dataTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    var uploadTask: URLSessionUploadTask?
    
    var config: NetworkApiClientConfig
    
    init() {
        session = URLSession(configuration: .default)
        config = NetworkApiClientConfig()
    }
    
    // Generic Wrapper
    public func apiCall<T: Decodable>(completion: @escaping (Result<T, APIError>) -> Void) {
        
        fetch { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                break
            case .success(let data):
                do {
                    let genericData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(genericData))
                } catch {
                    completion(.failure(.serialize))
                }
                break
            }
        }
    }
  
    private func fetch(completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = getUrl(withPath: config.path, query: config.query) else { fatalError("URL - incorrect format or missing string url") }
        guard let method = config.method else { fatalError("Method missing") }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("", forHTTPHeaderField: "x-access-token")
        
        if let body = config.body {
            request.httpBody = body
        }
        
        dataTask = session.dataTask(with: request, completionHandler: { data, res, err in
            
            if let error = err {
                completion(.failure(APIError.customError(message: error.localizedDescription, code: 500)))
                return
            }
            
            guard let data = data,
                  let response = res as? HTTPURLResponse else {
                completion(.failure(APIError.serverError))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    let message : String = (json?["message"] as? String) ?? "error code \(status)"
                    completion(.failure(.customError(message: message, code: status)))
                    
                    return
                }
                completion(.success(data))
            } catch {
                completion(.failure(APIError.request))
                
                return
            }
        })
        
        dataTask?.resume()
    }
    
    func addRequestBody<TRequest> (_ body: TRequest?) where TRequest: Encodable {
        config.body = try? JSONEncoder().encode(body)
    }
    
    private func getHost() -> String {
        return "http://127.0.0.1:2999"
    }
    
    private func getUrl(withPath path: String, query: String?) -> URL? {
        let host = getHost()
        let path = path
        var stringUrl = "\(host)/\(path)"
        if let query = query {
            stringUrl.append(query)
        }
        
        return URL(string: stringUrl)
    }
}

final class NetworkApiClientConfig: NSObject {
    var body: Data?
    var path: String = ""
    var query: String?
    var method: String?
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
