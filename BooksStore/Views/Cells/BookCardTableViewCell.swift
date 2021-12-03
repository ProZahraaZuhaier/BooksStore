//
//  BookCardTableViewCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 30/11/2021.
//

import UIKit

class BookCardTableViewCell: UITableViewCell {
    //MARK: - Set Properties and Variables
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    
    var bookInfo:BookModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        overrideUserInterfaceStyle = .dark
    }
//MARK: - Methods
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
    downloaadBookImage(imgeURL: imageUrlString!)
}
    
    func downloaadBookImage(imgeURL: String){
        let imageURL = URL(string: imgeURL)
        
        URLSession.shared.dataTask(with: imageURL!) { data, response, error in
            
            if error == nil && data != nil {
//                if self.bookInfo?.volumeInfo?.imageLinks?.thumbnail == imgeURL
                   DispatchQueue.main.async {
                    self.bookCoverImage.image = UIImage(data: data!)
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

