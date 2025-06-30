//
//  Requests.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}
