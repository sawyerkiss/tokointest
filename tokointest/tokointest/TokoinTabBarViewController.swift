//
//  TokoinTabBarViewController.swift
//  tokointest
//
//  Created by Macintosh HD on 8/18/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class TokoinTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.tabBarController?.tabBar.selectedItem = item
    }

}
