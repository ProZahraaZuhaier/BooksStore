//
//  AuthorNameCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 04/12/2021.
//

import UIKit

class AuthorNameCell: UITableViewCell {

    @IBOutlet weak var authorName: UILabel!
    
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
            self.authorName.text = self.bookInfo!.volumeInfo?.authors?[0] ?? "Unknown author"
          
        }
    }
}
