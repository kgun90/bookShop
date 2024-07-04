//
//  Repository.swift
//  BookShop
//
//  Created by gkang on 6/24/24.
//

import Foundation

class SearchRepository {
    static let shared = SearchRepository()
    
    func getSearchResult(keyword: String, page: Int, completion: @escaping(Decodable) -> Void) {
        
        NetworkService(route: .search).request(path: "/\(keyword)/\(page)", method: .get, type: SearchResponse.self) { response in
            if let response = response {
                completion(response)
                return
            }
        }
    }
    
    func getBookDetail(isbn13: String, completion: @escaping(Decodable) -> Void) {
        
        NetworkService(route: .books).request(path: "/\(isbn13)", method: .get, type: DetailResponse.self) { response in
            if let response = response {
                completion(response)
                return
            }
        }
    }
}
