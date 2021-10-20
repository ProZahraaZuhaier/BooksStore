//
//  Sci-FiViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import UIKit

class Sci_FiViewController: UIViewController {

    @IBOutlet weak var BookCollectionView: UICollectionView!
    var sci_Fi_CategoryData : [BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        BookCollectionView.delegate = self
        BookCollectionView.dataSource = self
        
        
        NetworkService.shared.fetchBooks(route: .Sci_Fi_Books, method: .get) { result in
         
            switch result {
            
            case .success(let data):
                self.sci_Fi_CategoryData = data
                self.BookCollectionView.reloadData()
                
                print(self.sci_Fi_CategoryData)
            case .failure(let error):
                print(error)
            }
        }
    }
    



}
extension Sci_FiViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sci_Fi_CategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomBookCell", for: indexPath) as! CustomBookCell
        let data = sci_Fi_CategoryData[indexPath.row]
        cell.configureCell(with: data)
        return cell
    }
    
    
}
