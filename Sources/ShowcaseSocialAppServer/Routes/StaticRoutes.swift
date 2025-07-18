//
//  StaticRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation
import Swifter

struct StaticRoutes {
    static func register(on server: HttpServer) {
        server.GET["/Uploads/ProfilePhotos/:filename"] = { request in
            guard let filename = request.params[":filename"] else {
                return .notFound
            }

            let profilePhotosDir = PathHelper.getProfilePhotosDirectory()
            let fileURL = profilePhotosDir.appendingPathComponent(filename)

            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                return .notFound
            }

            return shareFile(fileURL.path)(request)
        }
    }
}
