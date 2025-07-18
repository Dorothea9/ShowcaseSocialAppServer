//
//  PostRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 10/07/2025.
//

import Foundation
import Swifter

struct PostRoutes {
    static func register(on server: HttpServer, serviceContainer: ServiceContainer) {
        server.GET["/posts"] = { request in
            handleGetPosts(for: request, serviceContainer: serviceContainer)
        }

        server.POST["/posts"] = { request in
            handleCreatePost(for: request, serviceContainer: serviceContainer)
        }

        server.DELETE["/posts/:id"] = { request in
            handleDeletePost(for: request, serviceContainer: serviceContainer)
        }
    }
}

// MARK: - Route Handlers

private extension PostRoutes {
    static func handleGetPosts(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        let posts = serviceContainer.postService.getAllPosts()
        let (page, pageSize) = PaginationHelper.extractPaginationParams(from: request)

        let response = PostResponseBuilder.build(
            posts: posts,
            page: page,
            pageSize: pageSize,
            serviceContainer: serviceContainer,
            loggedInUserId: loggedInUserId
        )

        return JSONHelper.encodeResponse(response)
    }

    static func handleCreatePost(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let createPostRequest = JSONHelper.decodeJSON(CreatePostRequest.self, from: request) else {
            return .badRequest(.text("Invalid JSON"))
        }

        let postText = createPostRequest.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard ValidationHelper.validatePostText(postText) else {
            return .unprocessableEntity(.text("Post text must be between 1 and 250 characters long"))
        }

        guard let _ = serviceContainer.userService.getUser(for: loggedInUserId) else {
            return .internalServerError
        }

        let newPost = serviceContainer.postService.createNewPost(text: postText, userId: loggedInUserId)

        return JSONHelper.encodeCreatedResponse(newPost)
    }

    static func handleDeletePost(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let postId = request.params[":id"] else {
            return .badRequest(.text("Post ID is required"))
        }

        guard let post = serviceContainer.postService.getPost(for: postId) else {
            return .notFound(.text("Post not found"))
        }

        guard post.userId == loggedInUserId else {
            return .forbidden
        }

        serviceContainer.postService.removePost(with: postId, likeService: serviceContainer.likeService)

        return .noContent
    }
}
