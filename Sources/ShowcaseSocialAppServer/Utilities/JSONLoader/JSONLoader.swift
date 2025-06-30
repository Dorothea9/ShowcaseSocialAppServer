//
//  JSONLoader.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 30/06/2025.
//

import Foundation

final class JSONLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> [T] {
        let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                    .appendingPathComponent("Sources/ShowcaseSocialAppServer/Resources/PersistentData/\(filename).json")

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([T].self, from: data)
        } catch {
            fatalError("Failed to decode \(filename).json: \(error)")
        }
    }

    static func loadJSONFile<T: Decodable>(_ jsonFile: JSONFile) -> [T] {
        load(jsonFile.rawValue, as: T.self)
    }
}
