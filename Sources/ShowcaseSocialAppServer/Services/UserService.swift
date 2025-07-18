//
//  UserService.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 07/07/2025.
//

import Foundation

final class UserService {
    private lazy var users: [User] = {
        DataLoader.loadJSONFile(.users)
    }()

    func registerUser(email: String, firstName: String, lastName: String, hashedPassword: String) -> User {
        let newUser = User(
            id: UUID().uuidString,
            email: email,
            firstName: firstName,
            lastName: lastName,
            hashedPassword: hashedPassword
        )
        users.append(newUser)
        return newUser
    }

    func isEmailUsed(_ email: String) -> Bool {
        users.contains { $0.email == email }
    }

    func getUser(email: String, hashedPassword: String) -> User? {
        users.first { $0.email.lowercased() == email.lowercased() && $0.hashedPassword == hashedPassword }
    }

    func getUser(for id: String) -> User? {
        users.first(where: { $0.id == id })
    }

    func getUserDictionary() -> [String: User] {
        Dictionary(uniqueKeysWithValues: users.map { (String($0.id), $0) })
    }

    func updateUserProfilePhoto(for userId: String, newProfilePhotoUrl: String?) -> Bool {
        guard let index = users.firstIndex(where: { $0.id == userId }) else {
            return false
        }

        users[index].profilePhotoUrl = newProfilePhotoUrl
        return true
    }
}
