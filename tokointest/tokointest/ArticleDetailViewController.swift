//
//  ArticleDetailViewController.swift
//  tokointest
//
//  Created by Macintosh HD on 8/14/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleDetailViewController: UIViewController, UITextViewDelegate {

    var article: Article?
       
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var tvUrl: UITextView!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tvContent: UITextView!
    
    lazy var viewModel: ArticleDetailViewModel = {
        return ArticleDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    func initView() {
        self.navigationItem.title = article?.author
        self.tvUrl.delegate = self
    }
    
    func initViewModel() {
        viewModel.loadArticleDetailClosure = { [weak self] () in
                      DispatchQueue.main.async {
                          if let article = self?.viewModel.articleDetail {
                            self?.loadArticleDetail(article: article)
                          }
                      }
                  }
        viewModel.initData(article: article)
    }
           
    
    func loadArticleDetail(article: Article?) {
        imageView?.sd_setImage(with: URL( string: article?.urlToImage ?? "" ), completed: nil)
        labelTitle.text = "Title : " + (article?.title ?? "")
        labelDate.text = "Published Date : " + (article?.publishedAt ?? "")
        tvUrl.text = "Url : " + (article?.url ?? "")
        tvDescription.text = "Desctiption : " + (article?.description ?? "")
        tvContent.text = "Content : " + (article?.content ?? "")
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == article?.url) {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
            }
        return false
        }
}
