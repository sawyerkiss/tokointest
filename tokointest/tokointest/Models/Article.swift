//
//  Article.swift
//  tokointest
//
//  Created by Macintosh HD on 8/12/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class Articles: Codable {
    let articles: [Article]
}

class Article: Codable {
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    init?(dict: [String: Any]) {
        guard
            let author = dict["author"] as? String,
            let title = dict["title"] as? String,
            let description = dict["description"] as? String,
            let url = dict["url"] as? String,
            let urlToImage = dict["urlToImage"] as? String,
            let publishedAt = dict["publishedAt"] as? String,
            let content = dict["content"] as? String
            else {
                return nil
        }

        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }

}
