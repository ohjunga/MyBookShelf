//
//  BookSrt.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/20.
//

import Foundation

/* api에 사용될 Singletone Class */
class dataManager {
    static let shared : dataManager = dataManager()
    var searchResult : SearchResult?
    
    private init() {
        
    }
}

struct SearchResult: Codable {
    struct BookInfo: Codable {
        let title: String
        let link: String
        let image: String
        let author: String
        let price:String
        let publisher: String
        let pubdate: String
        let isbn: String
        let description: String
    }
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [BookInfo]
}
