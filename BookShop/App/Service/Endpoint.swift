//
//  Endpoint.swift
//  BookShop
//
//  Created by gkang on 6/24/24.
//

import Foundation

struct Endpoint {
    static let BASE_URL = "https://api.itbook.store/1.0"
    
    enum ROUTE: String {
        case books = "/books"
        case search = "/search"
    }
}
