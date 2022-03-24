//
//  LoginRepository.swift
//  Login
//
//  Created by David Diego Gomez on 24/01/2022.
//

import Foundation


typealias CustomResult = (Result<Data, APIError>) -> Void

protocol LoginRepositoryProtocol {
    func doLogin(body: LoginDataSource.Request, token: String, completion: @escaping CustomResult)
}

class LoginRepository: NewApiCall, LoginRepositoryProtocol {
 
    func doLogin(body: LoginDataSource.Request, token: String, completion: @escaping CustomResult) {
        config.path = "v1/firebase/auth/login"
        config.method = "POST"
        
        addBody(body)
        
        apiCallData { result in completion(result) }
    }
}

class LoginRepositoryMock: LoginRepositoryProtocol {
    func doLogin(body: LoginDataSource.Request, token: String, completion: @escaping CustomResult) {
        let any = Request.endpoint(to: .Login(userName: body.email, password: body.password))
        api_2(request: any) { result in
            completion(result)
        }
    }
    
    //this method is used in ui test
    private func api_2(request: URLRequest, completionBlock: @escaping (Result<Data, APIError>) -> Void) {
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

class NewApiCall {
    var session: URLSession
    var dataTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    var uploadTask: URLSessionUploadTask?
    
    var config: NetworkApiClientConfig
    
    init() {
        session = URLSession(configuration: .default)
        config = NetworkApiClientConfig()
    }
    
    // wrapper
    func apiCall<T: Decodable>(success: @escaping (T) -> (), fail: @escaping (APIError) ->()) {
      
        fetch { result in
            switch result {
            case .failure(let error):
                fail(error)
                break
            case .success(let data):
                do {
                    let genericData = try JSONDecoder().decode(T.self, from: data)
                    success(genericData)
                } catch {
                    fail(.serialize)
                }
                break
            }
        }
    }
    
    // wrapper
    func apiCallData(completion: @escaping CustomResult ) {
        fetch { result in completion(result) }
    }
    
    func fetch(completion: @escaping (Result<Data, APIError>) -> Void) {
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
    
    func addBody<TRequest> (_ body: TRequest?) where TRequest: Encodable {
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
