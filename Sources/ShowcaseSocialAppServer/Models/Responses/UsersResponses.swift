//
//  UsersResponses.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation

struct UserResponse: Encodable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    var profilePhotoUrl: String?

    init(from user: User) {
        self.id = user.id
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.profilePhotoUrl = user.profilePhotoUrl
    }
}
