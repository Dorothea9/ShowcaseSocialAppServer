//
//  LikesLookupHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation

typealias LikesLookup = (likeCountByPost: [String: Int], userLikedPosts: Set<String>)

struct LikesLookupHelper {
    static func createLikesLookup(from likes: [Like], loggedInUserId: String) -> LikesLookup {
        let likeCountByPost = Dictionary(grouping: likes, by: { $0.postId })
            .mapValues { $0.count }

        let userLikedPosts = Set(likes.filter { $0.userId == loggedInUserId }.map { $0.postId })

        return (likeCountByPost, userLikedPosts)
    }
}
