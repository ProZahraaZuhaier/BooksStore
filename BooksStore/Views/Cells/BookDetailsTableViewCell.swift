//
//  BookDetailsTableViewCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 16/11/2021.
//

import UIKit
import FolioReaderKit


class BookDetailsTableViewCell: UITableViewCell {
    
    //MARK: - Set properties & Variables
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookkTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var countPage: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var language: UILabel!

    
    var bookInfo:BookModel?
    var bookURL : URL?
    var isDownloaded = false
    
    
    //MARK: - View LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overrideUserInterfaceStyle = .dark
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}



//MARK: - Configure Cell
extension BookDetailsTableViewCell {
    //MARK:- Methods
    func configureCell (with data: BookModel) {
        self.bookInfo = data
        let pagecount = self.bookInfo?.volumeInfo?.pageCount
        
        DispatchQueue.main.async {
            self.bookkTitle.text = self.bookInfo!.volumeInfo?.title  ?? "Unknown title"
            self.authorName.text = self.bookInfo!.volumeInfo?.authors?[0] ?? "Unknown author"
            self.publishedDate.text = self.bookInfo?.volumeInfo?.publishedDate ?? "Unknown published date"
            self.countPage.text = pagecount as? String ?? "Unknown"
            self.language.text = self.bookInfo?.volumeInfo?.language ?? "EN"
            self.categories.text = self.bookInfo?.volumeInfo?.categories?[0] ?? "Unknown Category"
        }
        
        guard let _ = self.bookInfo!.volumeInfo?.imageLinks?.thumbnail  else {
            print(ErrorHandler.invalidURL)
            return
        }
        let imageUrlString = self.bookInfo!.volumeInfo?.imageLinks?.thumbnail
        
        
        let imageURL = URL(string: imageUrlString!)
        
        URLSession.shared.dataTask(with: imageURL!) { data, response, error in
            
            if error == nil && data != nil {
                if self.bookInfo?.volumeInfo?.imageLinks?.thumbnail == imageUrlString
                {   DispatchQueue.main.async {
                    self.bookImage.image = UIImage(data: data!)
                }
                    
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






