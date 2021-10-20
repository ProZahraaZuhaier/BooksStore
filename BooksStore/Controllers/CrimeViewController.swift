//
//  CrimeViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import UIKit

class CrimeViewController: UIViewController {

    @IBOutlet weak var BookCollectionView: UICollectionView!
    var crimeCategoryData : [BookModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BookCollectionView.delegate = self
        BookCollectionView.dataSource = self
        
        
        NetworkService.shared.fetchBooks(route: .CrimeBooks, method: .get) { result in
         
            switch result {
            
            case .success(let data):
                self.crimeCategoryData = data
                self.BookCollectionView.reloadData()
                
                print(self.crimeCategoryData)
            case .failure(let error):
                print(error)
            }
        }
    }
    


}

extension CrimeViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return crimeCategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomBookCell", for: indexPath) as! CustomBookCell
        let data = crimeCategoryData[indexPath.row]
        cell.configureCell(with: data)
        return cell
    }
    
    
}
