//
//  CustomBookCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import UIKit

class CustomBookCell: UICollectionViewCell {
    
    //MARK:- Set Properties and Variables
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    
    var bookInfo:BookModel?
    
    
    //MARK:- View LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialaization code
    }
    
    
    //MARK:- Methods
    func configureCell (with data: BookModel) {
        self.bookInfo = data
       
        DispatchQueue.main.async {
            self.bookTitle.text = self.bookInfo!.volumeInfo?.title  ?? "Unknown title"
            self.authorName.text = self.bookInfo!.volumeInfo?.authors?[0] ?? "Unknown author"
            self.publishedDate.text = self.bookInfo?.volumeInfo?.publishedDate ?? "Unknown published date"
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
                    self.bookCoverImage.image = UIImage(data: data!)
                }
                
                }
                
            }
            else {
                
                DispatchQueue.main.async {
                    self.bookCoverImage.image = UIImage(named: "placeholderImage")
                }
                print(error)
            }
        }.resume()
    }
}

