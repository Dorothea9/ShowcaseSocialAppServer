//
//  ServiceContainer.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation

final class ServiceContainer {
    let userService = UserService()
    let postService = PostService()
    let authService = AuthService()
    let likeService = LikeService()
}
