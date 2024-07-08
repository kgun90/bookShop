//
//  BookManager.swift
//  BookShop
//
//  Created by gkang on 7/4/24.
//

import Foundation

class BookManager {
    static let shared = BookManager()
    
    private init() {}
    
    private func store(key: String, data: LocalBookData) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private func load(key: String) -> LocalBookData? {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            return (try? decoder.decode(LocalBookData.self, from: data))
        }
        return nil
    }
    
    func getFavorite(isbn13 key: String) -> Bool {
        return load(key: key)?.isFavorite ?? false
    }
    
    func setFavorite(isbn13 key: String) {
        var localData: LocalBookData
        if let data = load(key: key) {
            localData = LocalBookData(isFavorite: !data.isFavorite, userRating: data.userRating)
        } else {
            localData = LocalBookData(isFavorite: true)
        }
        store(key: key, data: localData)
    }

    func getRating(isbn13 key: String) -> Int? {
        return load(key: key)?.userRating
    }
    
    func setRating(isbn13 key: String, rate: Int?) {
        var localData: LocalBookData
        
        if let data = load(key: key) {
            localData = LocalBookData(isFavorite: data.isFavorite, userRating: rate)
        } else {
            localData = LocalBookData(userRating: rate)
        }
        store(key: key, data: localData)
    }
}
