//
//  JSONHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 07/07/2025.
//

import Foundation
import Swifter

struct JSONHelper {
    static func decodeJSON<T: Decodable>(_ type: T.Type, from request: HttpRequest) -> T? {
        guard !request.body.isEmpty,
              let requestData = String(bytes: request.body, encoding: .utf8)?.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(type, from: requestData) else {
            return nil
        }
        return decoded
    }

    static func encodeResponse<T: Encodable>(_ object: T) -> HttpResponse {
        do {
            let data = try JSONEncoder().encode(object)
            return .ok(.data(data, contentType: Constants.ContentTypes.applicationJson))
        } catch {
            return .internalServerError
        }
    }

    static func encodeCreatedResponse<T: Encodable>(_ object: T) -> HttpResponse {
        do {
            let data = try JSONEncoder().encode(object)
            return .created(.data(data, contentType: Constants.ContentTypes.applicationJson))
        } catch {
            return .internalServerError
        }
    }
}
