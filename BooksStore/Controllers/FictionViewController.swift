//
//  FictionViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import UIKit

class FictionViewController: UIViewController {
    var fictionData : [BookModel] = []
    @IBOutlet weak var BooksCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        BooksCollectionView.delegate = self
        BooksCollectionView.dataSource = self
        
        
        NetworkService.shared.fetchBooks(route: .FictionBooks, method: .get) { result in
         
            switch result {
            
            case .success(let data):
                self.fictionData = data
                self.BooksCollectionView.reloadData()
                
                print(self.fictionData)
            case .failure(let error):
                print(error)
            }
        }
       
    }

}


extension FictionViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fictionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomBookCell", for: indexPath) as! CustomBookCell
        let data = fictionData[indexPath.row]
        cell.configureCell(with: data)
        return cell
    }
    
    
}
