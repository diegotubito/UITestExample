//
//  UserModel.swift
//  Login
//
//  Created by David Diego Gomez on 24/01/2022.
//

import Foundation

struct User: Decodable {
    var uid: String
    var displayName: String
    var email: String
    var emailVerified: Bool
    var phoneNumber: String?
    var photoURL: String?
    var token: String
}


