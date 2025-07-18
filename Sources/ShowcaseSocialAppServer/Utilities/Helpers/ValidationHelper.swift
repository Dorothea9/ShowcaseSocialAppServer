//
//  ValidationHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation

struct ValidationHelper {
    static func validatePostText(_ text: String) -> Bool {
        guard !text.isEmpty &&
              text.count >= Constants.Post.minTextLength &&
              text.count <= Constants.Post.maxTextLength else {
            return false
        }
        return true
    }

    static func validateEmail(_ text: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return text.range(of: emailRegex, options: .regularExpression) != nil
    }
}
