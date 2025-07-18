//
//  AuthHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation
import Swifter

struct AuthHelper {
    static func extractAuthenticatedUser(from request: HttpRequest, authService: AuthService) -> String? {
        guard let authHeader = request.headers["authorization"],
              authHeader.starts(with: Constants.Auth.bearerPrefix) else {
            return nil
        }

        let token = String(authHeader.dropFirst(Constants.Auth.bearerPrefix.count))
        guard authService.isValidToken(token),
              let userId = authService.extractUserID(from: token) else {
            return nil
        }

        return userId
    }
}
