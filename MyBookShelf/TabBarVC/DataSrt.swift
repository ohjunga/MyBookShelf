//
//  DataSrt.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/20.
//

import Foundation

struct saveData: Codable {
    let title: String
    let image: String
    let author: String
    let publisher: String
    let description: String
    let bookreport: String
    let id: Int
}
