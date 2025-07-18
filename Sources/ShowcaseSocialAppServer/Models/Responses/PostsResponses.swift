//
//  PostsResponses.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 10/07/2025.
//

import Foundation

struct PostsResponse: Encodable {
    let posts: [PostWithUserSummary]
    let pagination: PaginationInfo
}

struct PostWithUserSummary: Encodable {
    let id: String
    let createdAt: String
    let text: String
    let userSummary: UserSummary
    let isLiked: Bool
    let numberOfLikes: Int
}

struct UserSummary: Encodable {
    let id: String
    let firstName: String
    let lastName: String
    let profilePhotoUrl: String?
}
