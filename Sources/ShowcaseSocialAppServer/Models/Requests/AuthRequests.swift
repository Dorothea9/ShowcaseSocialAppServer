//
//  AuthRequests.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation

struct RegisterRequest: Decodable {
    let email: String
    let firstName: String
    let lastName: String
    let password: String
}

struct LoginRequest: Decodable {
    let email: String
    let password: String
}

struct LogoutRequest: Decodable {
    let refreshToken: String
}

struct RefreshTokenRequest: Decodable {
    let refreshToken: String
}
