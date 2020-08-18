//
//  SecondViewController.swift
//  tokointest
//
//  Created by Macintosh HD on 8/12/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class NewsViewController: TopHeadlineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        let user = User.getUserProfile()
                   viewModel.initFetchSpecificArticle(subject: user.keyword ?? "bitcoin")
                   self.navigationItem.title = user.keyword ?? "bitcoin"
    }


}

