//
//  BookCategoriesCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 04/12/2021.
//

import UIKit

class BookCategoriesCell: UITableViewCell {

    @IBOutlet weak var categories: UILabel!
    var bookInfo:BookModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with data: BookModel) {
        self.bookInfo = data
        DispatchQueue.main.async {
             self.categories.text = self.bookInfo?.volumeInfo?.categories?[0] ?? "Unknown Category"
          
        }
    }
}
