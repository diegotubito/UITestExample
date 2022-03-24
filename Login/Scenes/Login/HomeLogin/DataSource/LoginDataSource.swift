//
//  LoginDataSource.swift
//  Login
//
//  Created by David Diego Gomez on 24/01/2022.
//

import Foundation

struct LoginDataSource {
    struct Request: Encodable {
        var email: String
        var password: String
    }
    
    struct Response: Decodable {
        struct Success: Decodable {
            var uid: String
            var displayName: String
            var email: String
            var emailVerified: Bool
            var phoneNumber: String?
            var photoURL: String?
            var token: String
        }
        
        struct Failure: Decodable {
            var message: String
            var code: String
        }
        
       
    }
}
