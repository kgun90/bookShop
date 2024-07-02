//
//  Endpoint.swift
//  BookShop
//
//  Created by gkang on 6/24/24.
//

import Foundation

struct Endpoint {
    static let BASE_URL = "https://api.itbook.store"
    
    enum ROUTE: String {
        case books = "/1.0/books"
        case search = "/1.0/search"
    }
}
