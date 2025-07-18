//
//  AuthRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation
import Swifter

struct AuthRoutes {
    static func register(on server: HttpServer, serviceContainer: ServiceContainer) {
        server.POST["/auth/register"] = { request in
            handleRegister(for: request, serviceContainer: serviceContainer)
        }

        server.POST["/auth/login"] = { request in
            handleLogin(for: request, serviceContainer: serviceContainer)
        }

        server.POST["/auth/logout"] = { request in
            handleLogout(for: request, serviceContainer: serviceContainer)
        }

        server.POST["/auth/refresh"] = { request in
            handleRefresh(for: request, serviceContainer: serviceContainer)
        }
    }
}

// MARK: - Route Handlers

private extension AuthRoutes {
    static func handleRegister(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let data = JSONHelper.decodeJSON(RegisterRequest.self, from: request) else {
            return .badRequest(.text("Invalid JSON"))
        }

        // Validate email format
        guard ValidationHelper.validateEmail(data.email) else {
            return .unprocessableEntity(.text("Invalid email format"))
        }

        guard !serviceContainer.userService.isEmailUsed(data.email) else {
            return .conflict(.text("Email is already used"))
        }

        let hashedPassword = serviceContainer.authService.hashPassword(data.password)
        let createdUser = serviceContainer.userService.registerUser(
            email: data.email,
            firstName: data.firstName,
            lastName: data.lastName,
            hashedPassword: hashedPassword
        )

        guard let authResponse = serviceContainer.authService.generateTokenPair(for: createdUser) else {
            return .internalServerError
        }

        return JSONHelper.encodeResponse(authResponse)
    }

    static func handleLogin(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let data = JSONHelper.decodeJSON(LoginRequest.self, from: request) else {
            return .badRequest(.text("Invalid JSON"))
        }

        // Validate email format
        guard ValidationHelper.validateEmail(data.email) else {
            return .unprocessableEntity(.text("Invalid email format"))
        }

        guard let user = serviceContainer.userService.getUser(
            email: data.email,
            hashedPassword: serviceContainer.authService.hashPassword(data.password)
        ) else {
            return .unauthorized
        }

        guard let authResponse = serviceContainer.authService.generateTokenPair(for: user) else {
            return .internalServerError
        }

        return JSONHelper.encodeResponse(authResponse)
    }

    static func handleLogout(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let logoutRequest = JSONHelper.decodeJSON(LogoutRequest.self, from: request) else {
            return .badRequest(.text("Refresh token required"))
        }

        let success = serviceContainer.authService.revokeRefreshToken(logoutRequest.refreshToken)

        if success {
            return .noContent
        } else {
            return .unprocessableEntity(.text("Invalid or expired refresh token"))
        }
    }

    static func handleRefresh(for request: HttpRequest, serviceContainer: ServiceContainer) -> HttpResponse {
        guard let refreshRequest = JSONHelper.decodeJSON(RefreshTokenRequest.self, from: request) else {
            return .badRequest(.text("Refresh token required"))
        }

        guard let refreshResponse = serviceContainer.authService.refreshAccessToken(refreshToken: refreshRequest.refreshToken) else {
            return .unprocessableEntity(.text("Invalid or expired refresh token"))
        }

        return JSONHelper.encodeResponse(refreshResponse)
    }
}
