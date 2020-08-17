//
//  ArticleDetailViewController.swift
//  tokointest
//
//  Created by Macintosh HD on 8/14/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleDetailViewController: UIViewController {

    var imageUrl: String?
       
       @IBOutlet weak var imageView: UIImageView!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           if let imageUrl = imageUrl {
               imageView.sd_setImage(with: URL(string: imageUrl)) { (image, error, type, url) in
               
               }
           }
           
       }

}
