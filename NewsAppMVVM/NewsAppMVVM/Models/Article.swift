//
//  Article.swift
//  NewsAppMVVM
//
//  Created by sookim on 10/30/23.
//

import Foundation

struct ArticlesList: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
}
