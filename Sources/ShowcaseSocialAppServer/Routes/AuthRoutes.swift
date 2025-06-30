//
//  File.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Swifter

func registerAuthRoutes(on server: HttpServer, userService: UserService, authService: AuthService) {
    server["/auth/register"] = { request in
        guard let data = decodeJSON(RegisterRequest.self, from: request) else {
            return .badRequest(.text("Invalid JSON"))
        }

        guard !userService.isEmailUsed(data.email) else {
            return .badRequest(.text("Email is already used"))
        }

        let hashedPassword = authService.hashPassword(data.password)
        userService.registerUser(
            email: data.email,
            firstName: data.firstName,
            lastName: data.lastName,
            hashedPassword: hashedPassword
        )

        guard let token = authService.generateToken(for: data.email) else {
            return .internalServerError
        }

        return .ok(.json(["token": token]))
    }

    server["/auth/login"] = { request in
        guard let data = decodeJSON(LoginRequest.self, from: request) else {
            return .badRequest(.text("Invalid JSON"))
        }

        guard let user = userService.getUser(email: data.email, hashedPassword: authService.hashPassword(data.password)) else {
            return .unauthorized
        }

        guard let token = authService.generateToken(for: user.email) else {
            return .internalServerError
        }

        return .ok(.json(["token": token]))
    }
}
