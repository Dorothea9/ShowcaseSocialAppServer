//
//  File.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 30/06/2025.
//

import Foundation

struct Post: Codable {
    let id: String
    let creationDate: Date
    let text: String
    let isLiked: Bool
    let userSummary: UserSummary
}

struct UserSummary: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let profilePictureURLString: String
}
