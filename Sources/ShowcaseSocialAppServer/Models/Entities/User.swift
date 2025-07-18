//
//  User.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 07/07/2025.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    var profilePhotoUrl: String?
    let hashedPassword: String
}
