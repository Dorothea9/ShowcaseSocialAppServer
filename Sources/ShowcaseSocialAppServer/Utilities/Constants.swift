//
//  Constants.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 10/07/2025.
//

import Foundation

struct Constants {
    static let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter
    }()

    struct Pagination {
        static let defaultPage = 1
        static let defaultPageSize = 20
        static let maxPageSize = 50
    }

    struct Post {
        static let minTextLength = 1
        static let maxTextLength = 250
    }

    struct Auth {
        static let accessTokenExpirationTime: TimeInterval = 15 * 60 // 15 minutes
        static let refreshTokenExpirationTime: TimeInterval = 7 * 24 * 60 * 60 // 7 days
        static let bearerPrefix = Constants.Auth.tokenType + " "
        static let tokenType = "Bearer"
    }

    struct ContentTypes {
        static let applicationJson = "application/json"
    }
}
