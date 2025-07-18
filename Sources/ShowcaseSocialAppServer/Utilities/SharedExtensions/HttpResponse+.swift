//
//  HttpResponse+.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 09/07/2025.
//

import Foundation
import Swifter

extension HttpResponse {
    static var noContent: HttpResponse {
        .raw(204, "No Content", [:], nil)
    }

    static func created(_ body: HttpResponseBody) -> HttpResponse {
        .raw(201, "Created", ["Content-Type": "application/json"]) { writer in
            switch body {
            case .data(let data, _):
                try writer.write(data)
            case .text(let text):
                try writer.write(text.data(using: .utf8) ?? Data())
            case .json(let object):
                let data = try JSONSerialization.data(withJSONObject: object)
                try writer.write(data)
            default:
                fatalError("Unsupported body type")
            }
        }
    }

    static func notFound(_ body: HttpResponseBody) -> HttpResponse {
        .raw(404, "Not Found", ["Content-Type": "application/json"]) { writer in
            switch body {
            case .data(let data, _):
                try writer.write(data)
            case .text(let text):
                try writer.write(text.data(using: .utf8) ?? Data())
            case .json(let object):
                let data = try JSONSerialization.data(withJSONObject: object)
                try writer.write(data)
            default:
                fatalError("Unsupported body type")
            }
        }
    }

    static func conflict(_ body: HttpResponseBody) -> HttpResponse {
        .raw(409, "Conflict", ["Content-Type": "application/json"]) { writer in
            switch body {
            case .text(let text):
                try writer.write(text.data(using: .utf8) ?? Data())
            default:
                fatalError("Unsupported body type")
            }
        }
    }

    static func unprocessableEntity(_ body: HttpResponseBody) -> HttpResponse {
        .raw(422, "Unprocessable Entity", ["Content-Type": "application/json"]) { writer in
            switch body {
            case .data(let data, _):
                try writer.write(data)
            case .text(let text):
                try writer.write(text.data(using: .utf8) ?? Data())
            case .json(let object):
                let data = try JSONSerialization.data(withJSONObject: object)
                try writer.write(data)
            default:
                fatalError("Unsupported body type")
            }
        }
    }
}
