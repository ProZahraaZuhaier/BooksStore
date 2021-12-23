//
//  CategoriesCollectionViewCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 23/12/2021.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
//MARK: - Configure Cell
extension CategoriesCollectionViewCell {
    
    func configureCell(data: CategoriesModel){
        self.categoryName.text = data.categoryName ?? "dramaii"
        self.categoryImage.image = UIImage(named: data.categoryName ?? "drama" )
    }
}
