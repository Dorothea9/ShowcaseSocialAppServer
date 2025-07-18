//
//  File.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 07/07/2025.
//

import Foundation

struct Post: Codable, Comparable {
    let id: String
    let createdAt: String
    let text: String
    let userId: String

    static func < (lhs: Post, rhs: Post) -> Bool {
        lhs.createdAt < rhs.createdAt
    }
}
