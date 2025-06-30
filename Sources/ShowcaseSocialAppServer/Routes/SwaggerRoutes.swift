//
//  File.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Foundation
import Swifter

func registerSwaggerRoutes(on server: HttpServer) {
    let projectDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let swaggerDir = projectDir.appendingPathComponent("Sources/ShowcaseSocialAppServer/Swagger")

    let swaggerPath = swaggerDir.appendingPathComponent("swagger.yaml").path
    let swaggerUIPath = swaggerDir.appendingPathComponent("swagger-ui.html").path

    server["/swagger.yaml"] = shareFile(swaggerPath)
    server["/swagger"] = shareFile(swaggerUIPath)
}
