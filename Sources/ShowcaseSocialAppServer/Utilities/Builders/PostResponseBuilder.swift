//
//  PostResponseBuilder.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation

struct PostResponseBuilder {
    static func build(
        posts: [Post],
        page: Int,
        pageSize: Int,
        serviceContainer: ServiceContainer,
        loggedInUserId: String
    ) -> PostsResponse {
        guard !posts.isEmpty else {
            let emptyResponse = PostsResponse(
                posts: [],
                pagination: PaginationHelper.createPaginationInfo(page: page, pageSize: pageSize, totalItems: 0)
            )
            return emptyResponse
        }

        let totalItems = posts.count
        let paginatedPosts = PaginationHelper.paginateArray(posts, page: page, pageSize: pageSize)

        let userDictionary = serviceContainer.userService.getUserDictionary()
        let likesLookup = serviceContainer.likeService.getLikesLookup(for: loggedInUserId)

        let postsWithUserSummary = transformToPostWithUserSummary(
            posts: paginatedPosts,
            userDictionary: userDictionary,
            likeCountByPost: likesLookup.likeCountByPost,
            userLikedPosts: likesLookup.userLikedPosts,
            loggedInUserId: loggedInUserId
        )

        return PostsResponse(
            posts: postsWithUserSummary,
            pagination: PaginationHelper.createPaginationInfo(page: page, pageSize: pageSize, totalItems: totalItems)
        )
    }
}

private extension PostResponseBuilder {
    static func transformToPostWithUserSummary(
        posts: [Post],
        userDictionary: [String: User],
        likeCountByPost: [String: Int],
        userLikedPosts: Set<String>,
        loggedInUserId: String
    ) -> [PostWithUserSummary] {
        posts.compactMap { post -> PostWithUserSummary? in
            guard let user = userDictionary[post.userId] else { return nil }

            let isLiked = userLikedPosts.contains(post.id)

            return PostWithUserSummary(
                id: post.id,
                createdAt: post.createdAt,
                text: post.text,
                userSummary: UserSummary(
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    profilePhotoUrl: user.profilePhotoUrl
                ),
                isLiked: isLiked,
                numberOfLikes: likeCountByPost[post.id] ?? 0
            )
        }
    }
}
