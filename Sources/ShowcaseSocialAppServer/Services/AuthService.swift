//
//  AuthService.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation
import CryptoKit
import SwiftJWT

final class AuthService {
    private let jwtSecret = UUID().uuidString

    private var validRefreshTokens: Set<String> = []
}

// MARK: - Password Hashing

extension AuthService {
    func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Token Generation

extension AuthService {
    func generateTokenPair(for user: User) -> AuthResponse? {
        guard let accessToken = generateToken(.access, for: user.id),
              let refreshToken = generateToken(.refresh, for: user.id) else {
            return nil
        }

        validRefreshTokens.insert(refreshToken)

        let userInfo = UserInfo(
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            profilePhotoUrl: user.profilePhotoUrl
        )

        return AuthResponse(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: userInfo
        )
    }

    private func generateToken(_ type: TokenType, for userId: String) -> String? {
        let expiration = Date().addingTimeInterval(type.expirationTime)
        let claims = UserClaims(sub: userId, exp: expiration, type: type)
        var jwt = JWT(claims: claims)
        let signer = JWTSigner.hs256(key: Data(jwtSecret.utf8))
        return try? jwt.sign(using: signer)
    }
}

// MARK: - Token Refresh

extension AuthService {
    func refreshAccessToken(refreshToken: String) -> RefreshTokenResponse? {
        guard validRefreshTokens.contains(refreshToken),
              let claims = extractClaims(from: refreshToken),
              claims.type == .refresh,
              claims.exp > Date() else {
            return nil
        }

        guard let newAccessToken = generateToken(.access, for: claims.sub) else {
            return nil
        }

        return RefreshTokenResponse(
            accessToken: newAccessToken
        )
    }
}

// MARK: - Token Validation

extension AuthService {
    func isValidToken(_ token: String) -> Bool {
        guard let claims = extractClaims(from: token) else {
            return false
        }

        guard claims.exp > Date() else {
            return false
        }

        if claims.type == .refresh {
            return validRefreshTokens.contains(token)
        }

        return true
    }
}

// MARK: - UserId Extraction

extension AuthService {
    func extractUserID(from token: String) -> String? {
        extractClaims(from: token)?.sub
    }
}

// MARK: - Token Revocation

extension AuthService {
    func revokeRefreshToken(_ refreshToken: String) -> Bool {
        validRefreshTokens.remove(refreshToken) != nil
    }
}

// MARK: - Claims Extraction

private extension AuthService {
    func extractClaims(from token: String) -> UserClaims? {
        let verifier = JWTVerifier.hs256(key: Data(jwtSecret.utf8))
        return try? JWT<UserClaims>(jwtString: token, verifier: verifier).claims
    }
}
