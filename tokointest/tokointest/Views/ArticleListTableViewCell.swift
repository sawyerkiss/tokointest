//
//  ArticleListTableViewCell.swift
//  tokointest
//
//  Created by Macintosh HD on 8/14/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
       @IBOutlet weak var dateLabel: UILabel!
       @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var authorLabel: UILabel!
       @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
       var articleListCellViewModel : ArticleListCellViewModel? {
           didSet {
            authorLabel.text = articleListCellViewModel?.author
               titleLabel.text = articleListCellViewModel?.title
               mainImageView?.sd_setImage(with: URL( string: articleListCellViewModel?.urlToImage ?? "" ), completed: nil)
               dateLabel.text = articleListCellViewModel?.publishedAt
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
