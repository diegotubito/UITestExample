//
//  Request.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

class Request {
    // Add necessary endpoint here
     enum EndpointType {
         case Login(userName: String, password: String)
    }
    
    private static func getPath(endpointName: EndpointType) -> String {
        switch endpointName {
        case .Login(userName: _, password: _):
            return "v1/firebase/auth/login"
        }
    }
    
    private static func getMethod(endpointName: EndpointType) -> String {
        switch endpointName {
        case .Login(userName: _, password: _):
            return "POST"
        }
    }
    
    private static func getBody(endpointName: EndpointType) -> [String: Any]? {
        switch endpointName {
        case .Login(userName: let userName, password: let password):
            let body = ["email": userName,
                        "password": password] as [String: Any]
            return body
        }
    }
    
    private static func getQuery(endpointName: EndpointType) -> String? {
        switch endpointName {
        case .Login(userName: _, password: _):
            return nil
        }
    }

}

extension Request {
    private static func getHost() -> String {
        return "http://127.0.0.1:2999"
    }
    
    private static func getUrl(endpointName: EndpointType) -> URL? {
        let host = getHost()
        let path = getPath(endpointName: endpointName)
        var stringUrl = "\(host)/\(path)"
        if let query = getQuery(endpointName: endpointName) {
            stringUrl.append(query)
        }
        return URL(string: stringUrl)
    }
    
    public static func endpoint(to: EndpointType) -> URLRequest {
        let token = ""
        
        guard let url = getUrl(endpointName: to) else {
            fatalError("URL - incorrect format")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = getMethod(endpointName: to)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "x-access-token")
        
        if let body = getBody(endpointName: to) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }

        return request
    }
}



