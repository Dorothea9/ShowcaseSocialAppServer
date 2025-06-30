//
//  PostRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 30/06/2025.
//

import Foundation
import Swifter

func registerPostRoutes(on server: HttpServer) {
    server["/posts"] = { request in
        let posts: [Post] = JSONLoader.loadJSONFile(.posts)

        do {
            let data = try JSONEncoder().encode(posts)
            return .ok(.data(data, contentType: "application/json"))
        } catch {
            return .internalServerError
        }
    }
}
