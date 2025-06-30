//
//  JSONDecoderHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Foundation
import Swifter

func decodeJSON<T: Decodable>(_ type: T.Type, from request: HttpRequest) -> T? {
    guard !request.body.isEmpty else { return nil }
    return try? JSONDecoder().decode(T.self, from: Data(request.body))
}
