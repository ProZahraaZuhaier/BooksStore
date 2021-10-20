//
//  CustomBookCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import UIKit

class CustomBookCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    var bookInfo:BookModel?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialaization code
        shadowView.layer.cornerRadius = 10
        cardView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.3)
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 8
    }
    
    func configureCell (with data: BookModel) {
        self.bookInfo = data
        bookTitle.text = self.bookInfo!.volumeInfo?.title
        authorName.text = self.bookInfo!.volumeInfo?.authors?[0]
        publishedDate.text = self.bookInfo?.volumeInfo?.publishedDate
        
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

