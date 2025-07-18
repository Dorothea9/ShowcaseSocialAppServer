//
//  FileHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation

struct FileHelper {
    static func extractFilename(from url: String?) -> String? {
        guard let url else { return nil }
        return URL(string: url)?.lastPathComponent
    }

    static func getFileExtension(from filename: String?) -> String? {
        guard let filename else { return nil }
        let pathExtension = URL(fileURLWithPath: filename).pathExtension
        return pathExtension.isEmpty ? nil : pathExtension
    }

    static func deleteFile(at url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}
