//
//  BookInfoCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 04/12/2021.
//

import UIKit

class BookInfoCell: UITableViewCell {

    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var pagesCount: UILabel!
    @IBOutlet weak var language: UILabel!
    
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
            self.publishedDate.text = self.bookInfo?.volumeInfo?.publishedDate ?? "Unknown published date"
            self.pagesCount.text = String(self.bookInfo?.volumeInfo?.pageCount ?? 0)
            self.language.text = self.bookInfo?.volumeInfo?.language ?? "EN"
          
        }
    }
}
