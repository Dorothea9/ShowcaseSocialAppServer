//
//  PostService.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 10/07/2025.
//

import Foundation

final class PostService {
    private lazy var posts: [Post] = {
        DataLoader.loadJSONFile(.posts)
    }()

    func getAllPosts() -> [Post] {
        return posts.sorted(by: >)
    }

    func getAllPosts(for userId: String) -> [Post] {
        return posts.filter { $0.userId == userId }.sorted(by: >)
    }

    func getPost(for id: String) -> Post? {
        posts.first(where: { $0.id == id })
    }

    func removePost(with id: String, likeService: LikeService) {
        likeService.removeAllLikes(for: id)
        posts.removeAll(where: { $0.id == id })
    }

    func createNewPost(text: String, userId: String) -> Post {
        let newPost = Post(
            id: UUID().uuidString,
            createdAt: Constants.dateFormatter.string(from: Date()),
            text: text,
            userId: userId
        )
        posts.append(newPost)
        return newPost
    }
}
