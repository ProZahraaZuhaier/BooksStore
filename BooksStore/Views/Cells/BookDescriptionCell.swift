//
//  BookDescriptionCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 04/12/2021.
//

import UIKit

class BookDescriptionCell: UITableViewCell {

    @IBOutlet weak var bookDescription: UILabel!
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
            self.bookDescription.text = self.bookInfo?.volumeInfo?.description ?? "not available"
          
        }
    }
}
