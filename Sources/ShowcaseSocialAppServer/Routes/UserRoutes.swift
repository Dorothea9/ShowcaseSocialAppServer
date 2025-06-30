//
//  File.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Foundation
import Swifter

// TODO: Needs change!
func registerUserRoutes(on server: HttpServer, userService: UserService, authService: AuthService) {
    server["/users"] = { request in
        guard let authHeader = request.headers["Authorization"], authHeader.starts(with: "Bearer "), // TODO: This should be moved to UserService
              authService.isValidToken(String(authHeader.dropFirst(7))) else {
            return .unauthorized
        }

        do {
            let data = try JSONEncoder().encode(userService.getAllUsers())
            return .ok(.data(data, contentType: "application/json"))
        } catch {
            return .internalServerError
        }
    }

    server["/users/:id"] = { request in
        guard let userIdString = request.params.first(where: { $0.0 == ":id" })?.1,
              let userId = Int(userIdString) else {
            return .badRequest(nil)
        }

        guard let user = userService.getUser(for: userId) else {
            return .notFound
        }

        do {
            let data = try JSONEncoder().encode(user)
            return .ok(.data(data, contentType: "application/json"))
        } catch {
            return .internalServerError
        }
    }
}
