//
//  PathHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation

struct PathHelper {
    static func getProjectRootDirectory() -> URL {
        let currentDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

        var searchDir = currentDir
        while searchDir.path != "/" {
            let packageSwiftPath = searchDir.appendingPathComponent("Package.swift")
            if FileManager.default.fileExists(atPath: packageSwiftPath.path) {
                return searchDir
            }
            searchDir = searchDir.deletingLastPathComponent()
        }

        return currentDir
    }

    static func getSourcesDirectory() -> URL {
        return getProjectRootDirectory()
            .appendingDirectoryToPath(.sources)
            .appendingDirectoryToPath(.showcaseSocialAppServer)
    }

    static func getDataDirectory() -> URL {
        getSourcesDirectory().appendingDirectoryToPath(.data)
    }

    static func getUploadsDirectory() -> URL {
        getSourcesDirectory().appendingDirectoryToPath(.uploads)
    }

    static func getProfilePhotosDirectory() -> URL {
        getUploadsDirectory().appendingDirectoryToPath(.profilePhotos)
    }

    static func getSwaggerDirectory() -> URL {
        getSourcesDirectory().appendingDirectoryToPath(.swagger)
    }

    static func getDataFileURL(for filename: String) -> URL {
        getDataDirectory().appendingPathComponent(filename)
    }

    static func getSwaggerFileURL(for filename: String) -> URL {
        getSwaggerDirectory().appendingPathComponent(filename)
    }

    static func getProfilePhotoPath(for fileName: String) -> String {
        "/\(Directory.uploads.rawValue)/\(Directory.profilePhotos.rawValue)/\(fileName)"
    }
}

extension PathHelper {
    enum Directory: String {
        case sources = "Sources"
        case showcaseSocialAppServer = "ShowcaseSocialAppServer"
        case data = "Data"
        case uploads = "Uploads"
        case profilePhotos = "ProfilePhotos"
        case swagger = "Swagger"
    }
}

private extension URL {
    func appendingDirectoryToPath(_ directory: PathHelper.Directory) -> URL {
        appendingPathComponent(directory.rawValue)
    }
}
