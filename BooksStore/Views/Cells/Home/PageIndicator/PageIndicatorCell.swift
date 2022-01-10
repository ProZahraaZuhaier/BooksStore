//
//  PageIndicatorCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 09/01/2022.
//

import UIKit

class PageIndicatorCell: UITableViewCell {

    @IBOutlet weak var pageControl: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
