//
//  Date.swift
//  BookShop
//
//  Created by gkang on 6/20/24.
//

import Foundation

extension DateFormatter {
    static let formatCoder: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()
    
    static let kst: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
