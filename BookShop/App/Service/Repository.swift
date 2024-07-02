//
//  Repository.swift
//  BookShop
//
//  Created by gkang on 6/24/24.
//

import Foundation

class SearchRepository {
    static let shared = SearchRepository()
    
    func getSearchResult(keyword: String, completion: @escaping(Decodable) -> Void) {       
        
        NetworkService(route: .search).request(path: "/\(keyword)", method: .get, type: SearchResponse.self) { response in
            if let response = response {
                completion(response)
                return
            }
        }
    }
}
