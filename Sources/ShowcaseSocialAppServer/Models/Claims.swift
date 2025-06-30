//
//  Claims.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Foundation
import SwiftJWT

struct UserClaims: Claims {
    let sub: String
    let exp: Date
}
