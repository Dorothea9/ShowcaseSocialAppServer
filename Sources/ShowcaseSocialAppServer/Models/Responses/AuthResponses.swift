//
//  AuthResponses.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation

struct UserInfo: Encodable {
    let id: String
    let firstName: String
    let lastName: String
    let profilePhotoUrl: String?
}

struct AuthResponse: Encodable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiresIn: Double = Constants.Auth.accessTokenExpirationTime
    let refreshTokenExpiresIn: Double = Constants.Auth.refreshTokenExpirationTime
    let tokenType: String = Constants.Auth.tokenType
    let user: UserInfo
}

struct RefreshTokenResponse: Encodable {
    let accessToken: String
    let expiresIn: Double = Constants.Auth.accessTokenExpirationTime
    let tokenType: String = Constants.Auth.tokenType
}
