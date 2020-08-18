//
//  ArticleDetailViewModel.swift
//  tokointest
//
//  Created by Macintosh HD on 8/17/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class ArticleDetailViewModel: NSObject {
    
    var articleDetail: Article? {
        didSet {
            self.loadArticleDetailClosure?()
        }
    }
    
    var loadArticleDetailClosure: (() -> ())?
    
    func initData(article: Article?) {
        self.articleDetail = article
    }
}
