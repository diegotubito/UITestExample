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
}
