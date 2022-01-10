//
//  SliderCollectionViewCell.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 09/01/2022.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sliderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension SliderCollectionViewCell {
    
    func configureCell(data: String){
        self.sliderImage.image = UIImage(named: data ?? "slider1" )
    }
}
