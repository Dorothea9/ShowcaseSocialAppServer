//
//  PaginationInfo.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 11/07/2025.
//

import Foundation

struct PaginationInfo: Encodable {
    let page: Int
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
}
