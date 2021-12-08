//
//  LoginModel.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

struct LoginModel {
    var user: User?
}

struct User: Decodable {
    var uid: String
    var displayName: String
    var email: String
    var emailVerified: Bool
    var phoneNumber: String?
    var photoURL: String?
    var token: String
}
