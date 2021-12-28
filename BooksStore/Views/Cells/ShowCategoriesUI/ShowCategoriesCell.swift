//
//  ShowCategoriesCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 25/12/2021.
//

import UIKit

class ShowCategoriesCell: UICollectionViewCell {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
//MARK: - Configure Cell
extension ShowCategoriesCell {
    
    func configureCell(data: BookModel){
        
        DispatchQueue.main.async {
            self.bookTitle.text = data.volumeInfo?.title ?? ""
        }
        
        guard let _ = data.volumeInfo?.imageLinks?.thumbnail  else {
            print(ErrorHandler.invalidURL)
            return
        }
        let imageUrlString = data.volumeInfo?.imageLinks?.thumbnail
        downloaadBookImage(imgeURL: imageUrlString!)
    }
}
//MARK: - Download Book Image Method
extension ShowCategoriesCell {
    func downloaadBookImage(imgeURL: String){
        let imageURL = URL(string: imgeURL)
        URLSession.shared.dataTask(with: imageURL!) { data, response, error in
            
            if error == nil && data != nil {
                   DispatchQueue.main.async {
                    self.bookImage.image = UIImage(data: data!)
                }
            }
            else {
                
                DispatchQueue.main.async {
                    self.bookImage.image = UIImage(named: "placeholderImage")
                }
                print(ErrorHandler.invalidURL)
            }
        }.resume()
    }
}
