//
//  FirstViewController.swift
//  tokointest
//
//  Created by Macintosh HD on 8/12/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class TopHeadlineViewController: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var firstLoad: Bool = true
    
    lazy var viewModel: ArticleListViewModel = {
        return ArticleListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !firstLoad {
            if self.tabBarController?.selectedIndex == 0 {
                initTabBar()
                refreshSpecificArticleData()
            } else if self.tabBarController?.selectedIndex == 1 {
                initTabBar()
                refreshAllArticlesData()
            }
        }
        firstLoad = false
    }
    
    func initView() {
        initTabBar()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        self.tabBarController?.delegate = self
    }
    
    func initTabBar() {
        if self.tabBarController?.selectedIndex == 0 {
            self.navigationItem.title = "Tokoin"
            self.tabBarController?.selectedIndex = 0
        } else {
            let user = User.getUserProfile()
            self.navigationItem.title = user.keyword ?? "bitcoin"
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    func initData() {
        viewModel.initFetchAllArticles()
        self.tabBarController?.selectedIndex = 0
        self.navigationItem.title = "Tokoin"
        firstLoad = true
    }
    
    func refreshAllArticlesData() {
        viewModel.initFetchAllArticles()
        self.navigationItem.title = "Tokoin"
        self.tabBarController?.selectedIndex = 0
    }
    
    func refreshSpecificArticleData() {
        let user = User.getUserProfile()
        viewModel.initFetchSpecificArticle(subject: user.keyword ?? "bitcoin")
        self.navigationItem.title = user.keyword ?? "bitcoin"
        self.tabBarController?.selectedIndex = 1
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.tabBarController?.selectedIndex == 1 {
            initTabBar()
            refreshSpecificArticleData()
        } else if self.tabBarController?.selectedIndex == 0 {
            initTabBar()
            refreshAllArticlesData()
        }
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TopHeadlineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? ArticleListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.articleListCellViewModel = cellVM
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.viewModel.userPressed(at: indexPath)
        if viewModel.isAllowSegue {
            return indexPath
        }else {
            return nil
        }
    }
    
}

extension TopHeadlineViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticleDetailViewController,
            let article = viewModel.selectedArticle {
            vc.article = article
        }
    }
}

