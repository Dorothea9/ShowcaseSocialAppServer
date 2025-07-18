//
//  UserRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 07/07/2025.
//

import Foundation
import Swifter

struct UserRoutes {
    static func register(on server: HttpServer, serviceContainer: ServiceContainer) {
        server["/users/:id"] = { request in
            handleGetUser(for: request, serviceContainer: serviceContainer)
        }

        server["/users/:id/posts"] = { request in
            handleGetUserPosts(for: request, serviceContainer: serviceContainer)
        }
    }
}

// MARK: - Route Handlers

private extension UserRoutes {
    static func handleGetUser(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let _ = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let userId = request.params[":id"] else {
            return .badRequest(.text("User ID is required"))
        }

        guard let user = serviceContainer.userService.getUser(for: userId) else {
            return .notFound(.text("User not found"))
        }

        return JSONHelper.encodeResponse(UserResponse(from: user))
    }

    static func handleGetUserPosts(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let userId = request.params[":id"] else {
            return .badRequest(.text("User ID is required"))
        }

        guard let _ = serviceContainer.userService.getUser(for: userId) else {
            return .notFound(.text("User not found"))
        }

        let userPosts = serviceContainer.postService.getAllPosts(for: userId)
        let (page, pageSize) = PaginationHelper.extractPaginationParams(from: request)

        let response = PostResponseBuilder.build(
            posts: userPosts,
            page: page,
            pageSize: pageSize,
            serviceContainer: serviceContainer,
            loggedInUserId: loggedInUserId
        )

        return JSONHelper.encodeResponse(response)
    }
}
