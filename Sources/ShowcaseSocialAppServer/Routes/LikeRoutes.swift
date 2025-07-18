//
//  LikeRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation
import Swifter

struct LikeRoutes {
    static func register(on server: HttpServer, serviceContainer: ServiceContainer) {
        server.POST["/posts/:postId/like"] = { request in
            handleLikePost(for: request, serviceContainer: serviceContainer)
        }

        server.DELETE["/posts/:postId/like"] = { request in
            handleUnlikePost(for: request, serviceContainer: serviceContainer)
        }

        server.GET["/users/:userId/likes"] = { request in
            handleGetUserLikedPosts(for: request, serviceContainer: serviceContainer)
        }
    }
}

// MARK: - Route Handlers

private extension LikeRoutes {
    static func handleLikePost(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let postId = request.params[":postId"] else {
            return .badRequest(.text("Post ID is required"))
        }

        guard let post = serviceContainer.postService.getPost(for: postId) else {
            return .notFound(.text("Post not found"))
        }

        guard post.userId != loggedInUserId else {
            return .unprocessableEntity(.text("Cannot like your own post"))
        }

        if serviceContainer.likeService.hasUserLikedPost(userId: loggedInUserId, postId: postId) {
            return .conflict(.text("Post already liked"))
        }

        let _ = serviceContainer.likeService.createLike(of: postId, by: loggedInUserId)
        return .noContent
    }

    static func handleUnlikePost(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let postId = request.params[":postId"] else {
            return .badRequest(.text("Post ID is required"))
        }

        guard let _ = serviceContainer.postService.getPost(for: postId) else {
            return .notFound(.text("Post not found"))
        }

        guard serviceContainer.likeService.hasUserLikedPost(userId: loggedInUserId, postId: postId) else {
            return .unprocessableEntity(.text("Post is not liked by user"))
        }

        serviceContainer.likeService.removeLike(of: postId, by: loggedInUserId)
        return .noContent
    }

    static func handleGetUserLikedPosts(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let userId = request.params[":userId"] else {
            return .badRequest(.text("User ID is required"))
        }

        guard let _ = serviceContainer.userService.getUser(for: userId) else {
            return .notFound(.text("User not found"))
        }

        let userLikes = serviceContainer.likeService.getLikesForUser(userId)
        let likedPostIds = userLikes.map { $0.postId }
        let likedPosts = serviceContainer.postService.getAllPosts().filter { likedPostIds.contains($0.id) }

        let (page, pageSize) = PaginationHelper.extractPaginationParams(from: request)

        let response = PostResponseBuilder.build(
            posts: likedPosts,
            page: page,
            pageSize: pageSize,
            serviceContainer: serviceContainer,
            loggedInUserId: loggedInUserId
        )

        return JSONHelper.encodeResponse(response)
    }
}
