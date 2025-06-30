//
//  File.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Foundation
import CryptoKit
import SwiftJWT

struct AuthService {
    private let jwtSecret = UUID().uuidString

    // Hashes a plain text password using SHA256
    func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    // Generates a JWT token for a given email
    func generateToken(for email: String) -> String? {
        let expiration = Date().addingTimeInterval(3600) // TODO: can take this one out
        let claims = UserClaims(sub: email, exp: expiration)
        var jwt = JWT(claims: claims)
        let signer = JWTSigner.hs256(key: Data(jwtSecret.utf8))
        return try? jwt.sign(using: signer)
    }

    // Verifies a JWT token and returns its claims if valid
    func isValidToken(_ token: String) -> Bool {
        let verifier = JWTVerifier.hs256(key: Data(jwtSecret.utf8))
        let claims = try? JWT<UserClaims>(jwtString: token, verifier: verifier).claims
        return claims != nil
    }
}
