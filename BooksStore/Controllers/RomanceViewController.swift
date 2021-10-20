//
//  RomanceViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import UIKit

class RomanceViewController: UIViewController {

    @IBOutlet weak var BookCollectionView: UICollectionView!
    var romanceCategoryData : [BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BookCollectionView.delegate = self
        BookCollectionView.dataSource = self
        
        
        NetworkService.shared.fetchBooks(route: .RomanceBooks, method: .get) { result in
         
            switch result {
            
            case .success(let data):
                self.romanceCategoryData = data
                self.BookCollectionView.reloadData()
                
                print(self.romanceCategoryData)
            case .failure(let error):
                print(error)
            }
        }
    }
    



}
extension RomanceViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return romanceCategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomBookCell", for: indexPath) as! CustomBookCell
        let data = romanceCategoryData[indexPath.row]
        cell.configureCell(with: data)
        return cell
    }
    
    
}
