//
//  Article.swift
//  NewsApp
//
//  Created by sookim on 10/24/23.
//

import Foundation

struct ArticlesList: Codable {
    let articles: [Article]
}

extension ArticlesList {
    
    // NewsAPI - dummyKey값
    static var all: Resource<ArticlesList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(NewsAPIKey.dummyNewsAPIKey)")!
        
        return Resource(url: url)
    }()
    
}

struct Article: Codable {
    let title: String
    let description: String?
}
