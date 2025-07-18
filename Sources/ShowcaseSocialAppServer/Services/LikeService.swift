//
//  LikeService.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation

final class LikeService {
    private lazy var likes: [Like] = {
        DataLoader.loadJSONFile(.likes)
    }()

    func hasUserLikedPost(userId: String, postId: String) -> Bool {
        likes.contains(where: { $0.userId == userId && $0.postId == postId })
    }

    func removeLike(of postId: String, by userId: String) {
        likes.removeAll(where: { $0.userId == userId && $0.postId == postId })
    }

    func createLike(of postId: String, by userId: String) -> Like {
        let newLike = Like(
            id: UUID().uuidString,
            userId: userId,
            postId: postId,
            createdAt: Constants.dateFormatter.string(from: Date())
        )
        likes.append(newLike)
        return newLike
    }

    func getLikesForUser(_ userId: String) -> [Like] {
        likes.filter { $0.userId == userId }
    }

    func removeAllLikes(for postId: String) {
        likes.removeAll(where: { $0.postId == postId })
    }

    func getLikesLookup(for userId: String) -> LikesLookup {
        LikesLookupHelper.createLikesLookup(from: likes, loggedInUserId: userId)
    }
}
