//
//  ArticleListViewModel.swift
//  tokointest
//
//  Created by Macintosh HD on 8/14/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class ArticleListViewModel: NSObject {
        let apiService: APIServiceProtocol

        private var articles: [Article] = [Article]()
        
        private var cellViewModels: [ArticleListCellViewModel] = [ArticleListCellViewModel]() {
            didSet {
                self.reloadTableViewClosure?()
            }
        }

        var isLoading: Bool = false {
            didSet {
                self.updateLoadingStatus?()
            }
        }
        
        var alertMessage: String? {
            didSet {
                self.showAlertClosure?()
            }
        }
        
        var numberOfCells: Int {
            return cellViewModels.count
        }
        
        var isAllowSegue: Bool = true
        
        var selectedArticle: Article?

        var reloadTableViewClosure: (()->())?
        var showAlertClosure: (()->())?
        var updateLoadingStatus: (()->())?

        init( apiService: APIServiceProtocol = APIService()) {
            self.apiService = apiService
        }
        
        func initFetchAllArticles() {
            self.isLoading = true
            apiService.fetchAllArticles{ [weak self] (success, articles, error) in
                self?.isLoading = false
                if let error = error {
                    self?.alertMessage = error.rawValue
                } else {
                    self?.processFetchedArticles(articles: articles)
                }
            }
        }
    
        func initFetchSpecificArticle(subject: String) {
        self.isLoading = true
        apiService.fetchSpecificArticles(subject: subject) { [weak self] (success, articles, error) in
                       self?.isLoading = false
                       if let error = error {
                           self?.alertMessage = error.rawValue
                       } else {
                           self?.processFetchedArticles(articles: articles)
                       }
            }
        }
        
        func getCellViewModel( at indexPath: IndexPath ) -> ArticleListCellViewModel {
            return cellViewModels[indexPath.row]
        }
        
        func createCellViewModel( article: Article?) -> ArticleListCellViewModel {
            return ArticleListCellViewModel( author: article?.author ?? "",
                                             title: article?.title ?? "",
                                             description: article?.description ?? "",
                                             url: article?.url ?? "",
                                             urlToImage: article?.urlToImage ?? "",
                                             publishedAt: article?.publishedAt ?? "",
                                             content: article?.content ?? "")
        }
        
        private func processFetchedArticles( articles: [Article] ) {
            self.articles = articles // Cache
            var vms = [ArticleListCellViewModel]()
            for article in articles {
                vms.append( createCellViewModel(article: article) )
            }
            self.cellViewModels = vms
        }
        
    }

    extension ArticleListViewModel {
        func userPressed( at indexPath: IndexPath ){
            let article = self.articles[indexPath.row]
            self.selectedArticle = article
        }
    }

    struct ArticleListCellViewModel {
        let author: String
        let title: String
        let description: String
        let url: String
        let urlToImage: String
        let publishedAt: String
        let content: String
    }
