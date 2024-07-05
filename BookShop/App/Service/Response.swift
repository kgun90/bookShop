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

// MARK: - DetailResponse
struct BookData: Codable {
    let title, subtitle, isbn13: String
    let price: String?
    let image: String?
    let url: String?
    
    let authors, error: String?
    let publisher, language, isbn10: String?
    let pages, year, rating, desc: String?
    let pdf: [String: String]?
}

struct LocalBookData: Codable {    
    var isFavorite: Bool = false
    var userRating: Int? = nil
}
