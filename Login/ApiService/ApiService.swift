//
//  ApiService.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

final class NetworkApiClientConfig: NSObject {
    var body: Data?
    var path: String = ""
    var query: String?
    var method: String?
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
