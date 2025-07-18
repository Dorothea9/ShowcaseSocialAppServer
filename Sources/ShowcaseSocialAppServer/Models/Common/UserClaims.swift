//
//  UserClaims.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 10/07/2025.
//

import Foundation
import SwiftJWT

struct UserClaims: Claims {
    let sub: String // User ID
    let exp: Date   // Expiration time
    let iat: Date   // Issued at time
    let type: TokenType // Token type (access or refresh)

    init(sub: String, exp: Date, type: TokenType = .access) {
        self.sub = sub
        self.exp = exp
        self.iat = Date()
        self.type = type
    }
}

enum TokenType: String, Codable {
    case access = "access"
    case refresh = "refresh"

    var expirationTime: TimeInterval {
        switch self {
        case .access:
            Constants.Auth.accessTokenExpirationTime
        case .refresh:
            Constants.Auth.refreshTokenExpirationTime
        }
    }
}
