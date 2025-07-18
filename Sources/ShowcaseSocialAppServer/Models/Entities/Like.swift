//
//  Like.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation

struct Like: Codable {
    let id: String
    let userId: String
    let postId: String
    let createdAt: String
}
