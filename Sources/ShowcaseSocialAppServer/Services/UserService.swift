//
//  UserService.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 25/06/2025.
//

import Foundation

final class UserService {
    private lazy var users: [User] = {
        JSONLoader.loadJSONFile(.users)
    }()

    // Registers a new user
    @discardableResult
    func registerUser(email: String, firstName: String, lastName: String, hashedPassword: String) -> User {
        let newUser = User(
            id: getNextUserId(),
            email: email,
            firstName: firstName,
            lastName: lastName,
            hashedPassword: hashedPassword
        )
        users.append(newUser)
        return newUser
    }

    // Checks if an email is already registered
    func isEmailUsed(_ email: String) -> Bool {
        users.contains { $0.email == email }
    }

    // Retrieves a user by email and hashed password (for login)
    func getUser(email: String, hashedPassword: String) -> User? {
        users.first { $0.email == email && $0.hashedPassword == hashedPassword }
    }

    func getUser(for id: Int) -> User? {
        users.first(where: { $0.id == id })
    }

    // Returns a list of all users (for /users)
    func getAllUsers() -> [User] {
        return users
    }
}

private extension UserService {
    func getNextUserId() -> Int {
        users.max(by: { $0.id > $1.id })?.id ?? 0 // TODO: can move this comparison to user
    }
}
