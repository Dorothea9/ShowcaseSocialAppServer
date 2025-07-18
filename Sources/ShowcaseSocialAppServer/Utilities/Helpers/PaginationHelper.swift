//
//  PaginationHelper.swift
//  ShowcaseSocialAppServer
//
//  Created by Dorota Belanová on 12/07/2025.
//

import Foundation
import Swifter

struct PaginationHelper {
    static func extractPaginationParams(from request: HttpRequest) -> (page: Int, pageSize: Int) {
        let pageParam = request.getQueryParam("page") ?? ""
        let pageSizeParam = request.getQueryParam("pageSize") ?? ""

        let page = Int(pageParam) ?? Constants.Pagination.defaultPage
        let requestedPageSize = Int(pageSizeParam) ?? Constants.Pagination.defaultPageSize

        let pageSize = min(requestedPageSize, Constants.Pagination.maxPageSize)

        return (page, pageSize)
    }

    static func createPaginationInfo(page: Int, pageSize: Int, totalItems: Int) -> PaginationInfo {
        let totalPages = totalItems == 0 ? 1 : (totalItems + pageSize - 1) / pageSize
        return PaginationInfo(
            page: page,
            pageSize: pageSize,
            totalItems: totalItems,
            totalPages: totalPages,
            hasNextPage: page < totalPages,
            hasPreviousPage: page > 1
        )
    }

    static func paginateArray<T>(_ array: [T], page: Int, pageSize: Int) -> [T] {
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, array.count)

        guard page > 0 && startIndex < array.count else {
            return []
        }

        return Array(array[startIndex..<endIndex])
    }
}

private extension HttpRequest {
    func getQueryParam(_ key: String) -> String? {
        queryParams.first(where: { $0.0 == key })?.1
    }
}
