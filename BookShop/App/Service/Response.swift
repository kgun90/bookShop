//
//  ErrorResponse.swift
//  BookShop
//
//  Created by gkang on 6/24/24.
//

import Foundation

struct ErrorResponse: Codable {
    let code: Int
    let message: String
}

// MARK: - SerachResponse
struct SearchResponse: Codable {
    let error, total, page: String
    let books: [BookData]?
}

// MARK: - Book
struct BookData: Codable {
    let title, subtitle, isbn13, price: String?
    let image: String?
    let url: String?
}
