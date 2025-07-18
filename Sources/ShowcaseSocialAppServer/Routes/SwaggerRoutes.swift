//
//  SwaggerRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 08/07/2025.
//

import Foundation
import Swifter

struct SwaggerRoutes {
    static func register(on server: HttpServer) {
        let swaggerYamlURL = PathHelper.getSwaggerFileURL(for: "swagger.yaml")
        let swaggerUIURL = PathHelper.getSwaggerFileURL(for: "swagger-ui.html")

        server["/swagger.yaml"] = shareFile(swaggerYamlURL.path)
        server["/swagger"] = shareFile(swaggerUIURL.path)
    }
}
