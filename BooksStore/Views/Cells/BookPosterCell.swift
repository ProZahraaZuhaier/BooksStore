//
//  BookPosterCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 04/12/2021.
//

import UIKit

class BookPosterCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
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
        let imageUrlString = self.bookInfo!.volumeInfo?.imageLinks?.thumbnail
        downloaadBookImage(imgeURL: imageUrlString!)
    }
    
    
    func downloaadBookImage(imgeURL: String){
        let imageURL = URL(string: imgeURL)
        
        URLSession.shared.dataTask(with: imageURL!) { data, response, error in
            
            if error == nil && data != nil {
    //     if self.bookInfo?.volumeInfo?.imageLinks?.thumbnail == imgeURL
                   DispatchQueue.main.async {
                    self.bookImage.image = UIImage(data: data!)
                   }
                }
            else {
                DispatchQueue.main.async {
                    self.bookImage.image = UIImage(named: "placeholderImage")
                }
                print(error)
            }
        }.resume()
    }
}
