//
//  ProfilePhotoRoutes.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation
import Swifter

struct ProfilePhotoRoutes {
    static func register(on server: HttpServer, serviceContainer: ServiceContainer) {
        let uploadsDirectory = PathHelper.getProfilePhotosDirectory()
        try? FileManager.default.createDirectory(at: uploadsDirectory, withIntermediateDirectories: true, attributes: nil)

        server.PUT["/profile-photo"] = { request in
            handleUploadProfilePhoto(for: request, serviceContainer: serviceContainer, uploadsDirectory: uploadsDirectory)
        }

        server.DELETE["/profile-photo"] = { request in
            handleDeleteProfilePhoto(for: request, serviceContainer: serviceContainer, uploadsDirectory: uploadsDirectory)
        }
    }
}

// MARK: - Route Handlers

private extension ProfilePhotoRoutes {
    static func handleUploadProfilePhoto(for request: HttpRequest, serviceContainer: ServiceContainer, uploadsDirectory: URL) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let user = serviceContainer.userService.getUser(for: loggedInUserId) else {
            return .notFound(.text("User not found"))
        }

        let formData = request.parseMultiPartFormData()
        guard !formData.isEmpty else {
            return .badRequest(.text("Missing file"))
        }

        for part in formData {
            if part.name == "photo", !part.body.isEmpty {
                let currentPhotoUrl = user.profilePhotoUrl
                let currentFilename = FileHelper.extractFilename(from: currentPhotoUrl)
                let isUpdate = currentPhotoUrl != nil

                let fileExtension = FileHelper.getFileExtension(from: part.fileName) ?? "jpg"
                let fileName = "\(loggedInUserId)_\(UUID().uuidString).\(fileExtension)"
                let fileURL = uploadsDirectory.appendingPathComponent(fileName)

                do {
                    try Data(part.body).write(to: fileURL)

                    let profilePhotoUrl = PathHelper.getProfilePhotoPath(for: fileName)

                    guard serviceContainer.userService.updateUserProfilePhoto(for: loggedInUserId, newProfilePhotoUrl: profilePhotoUrl) else {
                        return .internalServerError
                    }

                    if let oldFilename = currentFilename {
                        let oldFileURL = uploadsDirectory.appendingPathComponent(oldFilename)
                        FileHelper.deleteFile(at: oldFileURL)
                    }

                    let response = ProfilePhotoResponse(profilePhotoUrl: profilePhotoUrl)

                    return isUpdate ?
                    JSONHelper.encodeResponse(response) :
                    JSONHelper.encodeCreatedResponse(response)

                } catch {
                    return .internalServerError
                }
            }
        }

        return .unprocessableEntity(.text("No photo found in form data"))
    }

    static func handleDeleteProfilePhoto(for request: HttpRequest, serviceContainer: ServiceContainer, uploadsDirectory: URL) -> HttpResponse {
        guard let loggedInUserId = AuthHelper.extractAuthenticatedUser(from: request, authService: serviceContainer.authService) else {
            return .unauthorized
        }

        guard let user = serviceContainer.userService.getUser(for: loggedInUserId),
              let currentPhotoUrl = user.profilePhotoUrl else {
            return .notFound(.text("No profile photo found"))
        }

        let filename = FileHelper.extractFilename(from: currentPhotoUrl)

        guard serviceContainer.userService.updateUserProfilePhoto(for: loggedInUserId, newProfilePhotoUrl: nil) else {
            return .internalServerError
        }

        if let filename {
            let fileURL = uploadsDirectory.appendingPathComponent(filename)
            FileHelper.deleteFile(at: fileURL)
        }

        return .noContent
    }
}
