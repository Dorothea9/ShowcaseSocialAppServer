//
//  JSONLoader.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 10/07/2025.
//

import Foundation

struct DataLoader {
    static func loadJSONFile<T: Codable>(_ file: JSONFile) -> [T] {
        let fileURL = file.url

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Warning: JSON file not found at \(fileURL.path)")
            return []
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: data)
        } catch {
            print("Error loading JSON file \(file.rawValue): \(error)")
            return []
        }
    }
}

extension DataLoader {
    enum JSONFile: String {
        case users = "Users.json"
        case posts = "Posts.json"
        case likes = "Likes.json"

        var url: URL {
            PathHelper.getDataFileURL(for: self.rawValue)
        }
    }
}
